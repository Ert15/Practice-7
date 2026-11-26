import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_exception.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_model.dart';
import '../settings/settings_screen.dart';
import 'new_user_screen.dart';
import 'status_views.dart';
import 'user.dart';
import 'user_detail_screen.dart';
import 'users_model.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.watch<UsersModel>();
    final city = context.watch<SettingsModel>().city;

    final visible = city == null
        ? m.items
        : m.items.where((u) => u.address.city == city).toList();

    Widget body;
    if (m.loading) {
      body = const LoadingView();
    } else {
      body = switch (m.error) {
        null => Column(
          children: [
            if (m.fromCache) StaleBanner(onRetry: m.load),
            Expanded(child: UserList(visible, onRefresh: m.load)),
          ],
        ),
        NoConnectionException() => Offline(onRetry: m.load),
        NotFoundException() || UnauthorizedException() => const RequestError(),
        ServerException(:final status) => ServerError(status, onRetry: m.load),
        BadResponseException() => const GenericError(),
      };
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(city == null ? 'Users' : 'Users · $city'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const NewUserScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class UserList extends StatelessWidget {
  const UserList(this.users, {super.key, required this.onRefresh});

  final List<User> users;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: onRefresh,
    child: users.isEmpty
        ? ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: Text('No users')),
              ),
            ],
          )
        : ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: users.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final u = users[i];
              return ListTile(
                title: Text(u.name),
                subtitle: Text('${u.email}\n${u.address.city}'),
                isThreeLine: true,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => UserDetailScreen(user: u),
                  ),
                ),
              );
            },
          ),
  );
}
