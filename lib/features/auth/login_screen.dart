import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    await context.read<AuthModel>().login(_email.text.trim(), _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) {
                  final t = v?.trim() ?? '';
                  return (!t.contains('@') || !t.contains('.'))
                      ? 'Not an email'
                      : null;
                },
              ),
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (v) => (v == null || v.length < 8)
                    ? 'At least 8 characters'
                    : null,
              ),
              if (auth.error case final e?) ...[
                const SizedBox(height: 12),
                Text(
                  e,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: auth.busy ? null : _submit,
                child: Text(auth.busy ? 'Signing in...' : 'Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
