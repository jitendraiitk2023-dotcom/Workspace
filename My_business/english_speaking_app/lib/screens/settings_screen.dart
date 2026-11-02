import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  bool notifications = true;
  bool sound = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        children: [

          SwitchListTile(
            title: const Text("Dark Mode"),
            subtitle: const Text("Enable dark theme"),
            value: darkMode,
            onChanged: (value) {
              setState(() {
                darkMode = value;
              });
            },
          ),

          SwitchListTile(
            title: const Text("Notifications"),
            subtitle: const Text("Daily learning reminders"),
            value: notifications,
            onChanged: (value) {
              setState(() {
                notifications = value;
              });
            },
          ),

          SwitchListTile(
            title: const Text("Sound Effects"),
            subtitle: const Text("Button click sounds"),
            value: sound,
            onChanged: (value) {
              setState(() {
                sound = value;
              });
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About App"),
            subtitle: const Text("English Speaking AI v1.0"),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.help),
            title: const Text("Help & Support"),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text("Privacy Policy"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}