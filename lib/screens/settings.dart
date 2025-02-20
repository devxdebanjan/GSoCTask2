import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gsoc_debanjan/connections/ssh.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _sshPortController = TextEditingController();
  final TextEditingController _rigsController = TextEditingController();

  @override
  void dispose() {
    _ipController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _sshPortController.dispose();
    _rigsController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_ipController.text.isNotEmpty) {
      await prefs.setString('ipAddress', _ipController.text);
    }
    if (_usernameController.text.isNotEmpty) {
      await prefs.setString('username', _usernameController.text);
    }
    if (_passwordController.text.isNotEmpty) {
      await prefs.setString('password', _passwordController.text);
    }
    if (_sshPortController.text.isNotEmpty) {
      await prefs.setString('sshPort', _sshPortController.text);
    }
    if (_rigsController.text.isNotEmpty) {
      await prefs.setString('numberOfRigs', _rigsController.text);
    }
    print(prefs.getString('ipAddress'));
  }

  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _ipController.text = prefs.getString('ipAddress') ?? '';
      _usernameController.text = prefs.getString('username') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _sshPortController.text = prefs.getString('sshPort') ?? '';
      _rigsController.text = prefs.getString('numberOfRigs') ?? '';
    });
  }
  
  @override
  void initState() {
    super.initState();
    ssh = SSH();
    _loadSettings();
    _connectToLG();
  }
  
  bool val = false;
  late SSH ssh;

  Future<void> _connectToLG() async {
    bool? connected = await ssh.connect();
      try{setState(() {
          if(connected == null) connected = false;
          val = connected!;});}
          catch(e){print(e);}
    
  }

  void _handleTap() async {
    await _saveSettings();
    _connectToLG();  }           

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),

      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height:5.0),
            TextField(
              controller: _ipController,
          decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.computer),
                    labelText: 'IP address',
                    hintText: 'Enter Master IP',
                    border: OutlineInputBorder(),
                  ),
            ),
            SizedBox(height: 20.0,),
            TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'LG Username',
                    hintText: 'Enter your username',
                    border: OutlineInputBorder(),
                  ),
        ),
            SizedBox(height: 20.0,),
            TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'LG Password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
            SizedBox(height: 20),
            TextField(
                  controller: _sshPortController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.settings_ethernet),
                    labelText: 'SSH Port',
                    hintText: '22',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
            SizedBox(height: 20),
            TextField(
                  controller: _rigsController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.memory),
                    labelText: 'No. of LG rigs',
                    hintText: 'Enter the number of rigs',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _handleTap ,
                  child: Container(
                  height: 50.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color : val? Color(0xff4DBF60):Color(0xffFF7575),
                  ),
                  child: Center(child: Text(
                    val?"Connected":"Connect",
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  )
                )
                )
          ]
        ),
      ),
      );
  }
}