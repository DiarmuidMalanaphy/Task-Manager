import 'package:flutter/material.dart';
import 'package:task_management_system/apps/background_manager.dart';
import '../networking/auth.dart';

class IPSettings extends StatefulWidget {
  final BackgroundManager backgroundManager;

  IPSettings({required this.backgroundManager});

  @override
  _IPSettingsState createState() => _IPSettingsState();
}

class _IPSettingsState extends State<IPSettings> {
  final TextEditingController _ipController = TextEditingController();
  String? _errorText;
  late Auth _auth;

  @override
  void initState() {
    super.initState();
    _auth = Auth();
    _ipController.text = _auth.getIPAddress() ?? '';
  }

  bool _isValidIP(String ip) {
    final ipPattern = RegExp(
        r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');
    return ipPattern.hasMatch(ip);
  }

  void _verifyAndSaveIP() {
    final ip = _ipController.text.trim();
    if (_isValidIP(ip)) {
      _auth.setIPAddress(ip);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('IP address saved: $ip')),
      );
      Navigator.pop(context);
    } else {
      setState(() {
        _errorText = 'Invalid IP address';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          widget.backgroundManager
              .background, // Ensure backgroundManager has a 'background' widget
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black54),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'IP Settings',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 48), // To balance the layout
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _ipController,
                            decoration: InputDecoration(
                              labelText: 'IP Address',
                              hintText: 'Enter IP address',
                              errorText: _errorText,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 24.0),
                            ),
                            child: Text('Save', style: TextStyle(fontSize: 18)),
                            onPressed: _verifyAndSaveIP,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }
}
