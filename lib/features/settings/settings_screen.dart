import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_model.dart';
import '../users/users_model.dart';
import 'settings_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsModel>();
    final users = context.watch<UsersModel>().items;

    final cities = <String>{
      ?settings.city,
      for (final u in users) u.address.city,
    }.toList()..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark mode'),
            value: settings.dark,
            onChanged: settings.setDark,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: DropdownButtonFormField<String?>(
              initialValue: settings.city,
              decoration: const InputDecoration(labelText: 'City filter'),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('All cities'),
                ),
                for (final c in cities)
                  DropdownMenuItem<String?>(value: c, child: Text(c)),
              ],
              onChanged: settings.setCity,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: () async {
              final navigator = Navigator.of(context);
              await context.read<AuthModel>().logout();
              navigator.popUntil((r) => r.isFirst);
            },
          ),
        ],
      ),
    );
  }
}
