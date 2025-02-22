import 'package:dartssh2/dartssh2.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SSH {
  late String _host;
  late String _port;
  late String _username;
  late String _passwordOrKey;
  late String _numberOfRigs;
  bool connected = false;
  SSHClient? _client;
  String lgUrl = 'lg1:81';
  Future<void> initConnectionDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _host = prefs.getString('ipAddress') ?? 'default_host';
    _port = prefs.getString('sshPort') ?? '22';
    _username = prefs.getString('username') ?? 'lg';
    _passwordOrKey = prefs.getString('password') ?? 'lg';
    _numberOfRigs = prefs.getString('numberOfRigs') ?? '3';
  }

  Future<bool> connect() async {
    await initConnectionDetails();
      
    try {
      final socket = await SSHSocket.connect(
        _host,
        int.parse(_port),
      ).timeout(const Duration(seconds: 8));

      _client = SSHClient(
        socket,
        username: _username,
        onPasswordRequest: () => _passwordOrKey,
      );
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<SftpClient> getSftp() async {
    SftpClient sftp;
    try {
      sftp = await _client!.sftp();
    } on SSHChannelOpenError {
      await handleSSHChannelOpenError();
      sftp = await _client!.sftp();
    }
    return sftp;
  }

  Future<void> handleSSHChannelOpenError() async {
    await disconnect();
    await connect();
  }

  Future<bool> isConnected() async {
    if (_client == null || _client!.isClosed) return false;
    try {
      // Attempt to execute a simple command to check the connection status
      final result = await sendCommand('echo "check connection"');
      print(result);
      return result != null;
    } catch (e) {
      // If an exception occurs, the connection is not active
      return false;
    }
  }

  /// Disconnects the SSH client if connected.
  Future<void> disconnect() async {
    if (await isConnected()) {
      _client!.close();
    }
  }

  Future<String?> sendCommand(String command) async {
    try {
      print("sending command: $command");
      return utf8.decode(await _client!.run(command));
    } on SSHChannelOpenError {
      await handleSSHChannelOpenError();
      return utf8.decode(await _client!.run(command));
    } catch (e) {
      return null;
    }
  }

  Future<SSHSession?> execute(String command) async {
    try {
      if (_client == null) {
        print('SSH client is not initialized.');
        return null;
      }
      print("executing");
      final session = _client!.execute(command);
      print("execution complete");
      return session;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  Future<void> upload(String filePath) async {
    if (!await isConnected()) {
      return;
    }

    try {
      // Load file data from assets
      final ByteData data = await rootBundle.load(filePath);

      // Extract the file name from the provided filePath
      final fileName = filePath.split('/').last;
      print("Filename is: $fileName");
      final sftp = await _client!.sftp();

      // Upload file directly from byte data
      final remoteFile = await sftp.open(
        '/var/www/html/$fileName',
        mode: SftpFileOpenMode.create | SftpFileOpenMode.write,
      );

      // Convert ByteData to Uint8List and write it directly
      final uint8ListData = data.buffer.asUint8List();
      print("uploaded");
      await remoteFile.write(Stream.value(uint8ListData).cast<Uint8List>());
      await remoteFile.close();
    } catch (e) {
      final fileName = filePath.split('/').last;
      print("Filename is: $fileName");
      print('Error during file upload: $e');
    }
  }

  Future<void> sendKml(String kml, {List<String> images = const []}) async {
    if (!await isConnected()) {
      return;
    }

    try {
      for (String image in images) {
        await upload(image);
      }

      const fileName = 'upload.kml';

      SftpClient sftpClient = await getSftp();

      final remoteFile = await sftpClient.open('/var/www/html/$fileName',
          mode: SftpFileOpenMode.create |
              SftpFileOpenMode.write |
              SftpFileOpenMode.truncate);

      // Convert KML string to a stream and write it directly
      final kmlBytes = Uint8List.fromList(kml.codeUnits);
      await remoteFile.write(Stream.value(kmlBytes).cast<Uint8List>());
      await remoteFile.close();
      await sendCommand(
          'echo "http://$lgUrl/$fileName" > /var/www/html/kmls.txt');
    } catch (e) {
      print('Error during KML file upload: $e');
    }
  }

  /// Sends a KML file to a specific slave screen.
  ///
  /// [screenNumber] is the screen number.
  /// [kml] is the KML content to send.
  Future<void> sendKMLToSlave(int screenNumber, String kml, SSH lgssh) async {
    if (await lgssh.isConnected() == false) {
      print("not connected");
      return;
    }
    await lgssh.sendCommand(
        "echo '$kml' > /var/www/html/kml/slave_$screenNumber.kml");
  }
  
  Future<void> shutdown() async {
    final String pw = _passwordOrKey;
    if (!await isConnected()) {
      return;
    }

    
    try {
        // First send shutdown commands
        for (var i = int.parse(_numberOfRigs); i >= 1; i--) {
            await sendCommand(
                'sshpass -p $pw ssh -t lg$i "echo $pw | sudo -S poweroff"'
            );
        }
        
        // Properly close the SSH connection
        await disconnect();
        
        // Set connected status to false
        connected = false;
        
    } catch (e) {
        print('Shutdown error: $e');
        // Still try to close connection even if shutdown command fails
        await disconnect();
  }}

  Future<void> reboot() async {
    final String pw = _passwordOrKey;
    if (!await isConnected()) {
      return;
    }

    for  (var i = int.parse(_numberOfRigs); i >=1; i--) {
      await sendCommand(
          'sshpass -p $pw ssh -t lg$i "echo $pw | sudo -S reboot"');
    }
  }

  setRefresh() async {
    try {
      for (var i = 2; i <= 3; i++) {
        String search = '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href>';
        String replace =
            '<href>##LG_PHPIFACE##kml\\/slave_$i.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';

        await _client?.run(
            'sshpass -p $_passwordOrKey ssh -t lg$i \'echo $_passwordOrKey} | sudo -S sed -i "s/$replace/$search/" ~/earth/kml/slave/myplaces.kml\'');
        await _client?.run(
            'sshpass -p $_passwordOrKey} ssh -t lg$i \'echo $_passwordOrKey | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml\'');
        print("refreshed");
      }
    } catch (e) {
      print(e);
    }
  }

  static String lookAtLinear(double longitude, double latitude, double zoom, double tilt, double bearing) =>
      '<LookAt><longitude>$longitude</longitude><latitude>$latitude</latitude><range>$zoom</range><tilt>$tilt</tilt><heading>$bearing</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>';

}
