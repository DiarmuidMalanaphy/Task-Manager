import 'package:flutter/material.dart';
import 'package:task_management_system/apps/background_manager.dart';
import 'package:task_management_system/networking/task_management_system.dart';

class SettingsSidebar extends StatefulWidget {
  final BackgroundManager bm;
  final TaskManagementSystem tms;
  final Function() logout;
  final Function() deleteAccount;
  final Function() onSettingsChanged;

  SettingsSidebar({
    Key? key,
    required this.bm,
    required this.tms,
    required this.logout,
    required this.deleteAccount,
    required this.onSettingsChanged,
  }) : super(key: key);

  @override
  _SettingsSidebarState createState() => _SettingsSidebarState();
}

class _SettingsSidebarState extends State<SettingsSidebar> {
  bool _showCompletedTasks = false;

  void _updateSetting(Function updateFunction) {
    setState(() {
      updateFunction();
      widget.onSettingsChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildSectionTitle('Tasks Displayed'),
                    _buildSettingTile(
                      title: 'Show Completed Tasks',
                      subtitle: 'Display or hide completed tasks in the list',
                      value: widget.bm.personalConfigManager
                          .getShowCompletedTasksConfig(),
                      onChanged: (value) {
                        _updateSetting(() {
                          widget.bm.personalConfigManager
                              .flipShowCompletedTasksConfig();
                        });
                      },
                    ),
                    _buildSectionTitle('Background'),
                    _buildSettingTile(
                      title: 'Dark Mode',
                      subtitle: 'Switch between dark and light mode',
                      value: widget.bm.darkMode,
                      onChanged: (value) {
                        _updateSetting(() {
                          widget.bm.personalConfigManager.flipDarkModeConfig();
                          widget.bm.updateBackground();
                        });
                      },
                    ),
                    _buildSettingTile(
                      title: 'Animated Background',
                      subtitle: 'Enable or disable animated background',
                      value: widget.bm.animated,
                      onChanged: (value) {
                        _updateSetting(() {
                          widget.bm.personalConfigManager.flipAnimated();
                          widget.bm.updateBackground();
                        });
                      },
                    ),
                    _buildSettingTile(
                      title: 'Monkey Mode',
                      subtitle: 'Enable or disable monkey mode background',
                      value: widget.bm.monkeyMode,
                      onChanged: (value) {
                        _updateSetting(() {
                          widget.bm.personalConfigManager.flipMonkey();
                          widget.bm.updateBackground();
                        });
                      },
                    ),
                    SizedBox(height: 24),
                    _buildActionButton(
                      icon: Icons.logout,
                      label: 'Logout',
                      onTap: () {
                        Navigator.pop(context);
                        widget.logout();
                      },
                    ),
                    SizedBox(height: 12),
                    _buildActionButton(
                      icon: Icons.delete_forever,
                      label: 'Delete Account',
                      onTap: widget.deleteAccount,
                      isDangerous: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue.shade300,
            child: Text(
              widget.tms.username!.toString()[0],
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Welcome,',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          Text(
            widget.tms.username!.toString(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white.withOpacity(0.7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDangerous = false,
  }) {
    return ElevatedButton.icon(
      icon:
          Icon(icon, color: isDangerous ? Colors.white : Colors.blue.shade700),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: isDangerous ? Colors.white : Colors.blue.shade700,
        backgroundColor: isDangerous ? Colors.red : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onTap,
    );
  }
}
