import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/storage/secure_store.dart';
import 'user.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  Future<void> _open(BuildContext context, Uri uri) async {
    final messenger = ScaffoldMessenger.of(context);
    var ok = false;
    try {
      ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on PlatformException {
      ok = false;
    }
    if (!ok) {
      messenger.showSnackBar(
        const SnackBar(content: Text('No app can open this')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = user.address;
    final site = user.website;
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        children: [
          _row('Username', user.username),
          ListTile(
            leading: const Icon(Icons.mail),
            title: Text(user.email),
            onTap: () =>
                _open(context, Uri(scheme: 'mailto', path: user.email)),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(user.phone),
            onTap: () =>
                _open(context, Uri(scheme: 'tel', path: user.phoneDigits)),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(site ?? 'no website'),
            onTap: site == null
                ? null
                : () => _open(context, Uri.parse('https://$site')),
          ),
          _row('Address', '${a.street}, ${a.suite}\n${a.city}, ${a.zipcode}'),
          _row('Geo', '${a.geo.lat}, ${a.geo.lng}'),
          _row('Company', user.company.name),
          _row('Catch phrase', user.company.catchPhrase),
          if (kDebugMode)
            TextButton(
              onPressed: () async {
                final store = context.read<SecureStore>();
                final messenger = ScaffoldMessenger.of(context);
                final token = await store.readToken();
                if (token == null) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('No token')),
                  );
                  return;
                }
                await Clipboard.setData(ClipboardData(text: token));
                messenger.showSnackBar(
                  const SnackBar(content: Text('Token copied')),
                );
              },
              child: const Text('Copy token to clipboard (debug)'),
            ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) =>
      ListTile(title: Text(label), subtitle: Text(value));
}
