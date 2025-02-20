import 'dart:async';
import 'package:gsoc_debanjan/connections/ssh.dart';

class LGonnection {
  SSH ssh = SSH();
  bool? connected;
  Future<void> _connectToLG() async {
    connected = await ssh.connect();
    print("inside subhome: $connected");
    }

  void sendlogo() async{
    if(connected == null || connected == false) {
      await _connectToLG();
    } 
    
    String LgLogo = 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgXmdNgBTXup6bdWew5RzgCmC9pPb7rK487CpiscWB2S8OlhwFHmeeACHIIjx4B5-Iv-t95mNUx0JhB_oATG3-Tq1gs8Uj0-Xb9Njye6rHtKKsnJQJlzZqJxMDnj_2TXX3eA5x6VSgc8aw/s1600/LOGO+LIQUID+GALAXY-sq1000-+OKnoline.png';
    try{
      // ssh.executekml();
      String kml = '''<?xml version="1.0" encoding="UTF-8"?>
                        <kml xmlns="http://www.opengis.net/kml/2.2">
                          <Document>
                            <ScreenOverlay>
                              <name>Image Overlay</name>
                              <Icon>
                                <href>$LgLogo</href>
                              </Icon>
                              <overlayXY x="0.5" y="0.5" xunits="fraction" yunits="fraction"/>
                              <screenXY x="0.5" y="0.5" xunits="fraction" yunits="fraction"/>
                              <rotation>0</rotation>
                              <size x="0.5" y="0.5" xunits="fraction" yunits="fraction"/>
                            </ScreenOverlay>
                          </Document>
                        </kml>''';

// Call sendKMLToSlave with screen number 3
      ssh.setRefresh();
      await ssh.sendKMLToSlave(3, kml, ssh);
    }
    catch(e){print(e);}
  }

  void clearLogo() async{
    if(connected == null || connected == false) {
      await _connectToLG();
    }
    ssh.setRefresh();
    await ssh.sendKMLToSlave(3, '', ssh);
    await ssh.sendKMLToSlave(2, '', ssh);
  }

  void sendKML1() async{
    if(connected == null || connected == false) {
      await _connectToLG();
    }
    await ssh.upload('assets/kml/taj.kml');
    await ssh.execute('echo "http://lg1:81/taj.kml" > /var/www/html/kmls.txt');
  }

  void sendKML2() async{
    if(connected == null || connected == false) {
      await _connectToLG();
    }
  
    await ssh.upload("assets/kml/campnou.kml");
    await ssh.execute('echo "http://lg1:81/campnou.kml" > /var/www/html/kmls.txt');
  }

  void clearKML() async{
    if(connected == null || connected == false) {
      await _connectToLG();
    }
    ssh.execute('echo "" > /var/www/html/kmls.txt');
  }

  void reboot() async{
    if(connected == null || connected == false) {
      await _connectToLG();
    }
    ssh.reboot();
  }

  
  void shutdown() async{
    if(connected == null || connected == false) {
      await _connectToLG();
    }
    ssh.shutdown();
  }
  
}