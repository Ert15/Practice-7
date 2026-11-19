import 'package:flutter/material.dart';

import 'user.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final a = user.address;
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        children: [
          _row('Username', user.username),
          _row('Email', user.email),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(user.phone),
            subtitle: Text(user.phoneDigits),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(user.website ?? 'no website'),
            onTap: () {},
          ),
          _row('Address', '${a.street}, ${a.suite}\n${a.city}, ${a.zipcode}'),
          _row('Geo', '${a.geo.lat}, ${a.geo.lng}'),
          _row('Company', user.company.name),
          _row('Catch phrase', user.company.catchPhrase),
        ],
      ),
    );
  }

  Widget _row(String label, String value) =>
      ListTile(title: Text(label), subtitle: Text(value));
}
