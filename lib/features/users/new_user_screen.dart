import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_exception.dart';
import 'user.dart';
import 'users_model.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({super.key});

  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _email.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _emailRule(String? v) {
    final text = v?.trim() ?? '';
    if (text.isEmpty) return 'Required';
    if (!text.contains('@') || !text.contains('.')) return 'Not an email';
    return null;
  }

  String _message(ApiException e) => switch (e) {
        NoConnectionException() => 'No connection. Try again.',
        ServerException(:final status) => 'Server error ($status).',
        BadResponseException() => 'The server answered something unreadable.',
        NotFoundException() || UnauthorizedException() => 'Request rejected.',
      };

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final model = context.read<UsersModel>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final error = await model.addUser(
      User.draft(
        name: _name.text.trim(),
        username: _username.text.trim(),
        email: _email.text.trim(),
      ),
    );

    if (!mounted) return;
    if (error == null) {
      navigator.pop();
    } else {
      messenger.showSnackBar(SnackBar(content: Text(_message(error))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final saving = context.watch<UsersModel>().saving;
    return Scaffold(
      appBar: AppBar(title: const Text('New user')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: _required,
              ),
              TextFormField(
                controller: _username,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: _required,
              ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: _emailRule,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: saving ? null : _save,
                child: Text(saving ? 'Saving...' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
