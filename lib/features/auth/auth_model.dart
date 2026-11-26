import 'package:flutter/foundation.dart';

import '../../core/storage/secure_store.dart';

class AuthModel extends ChangeNotifier {
  AuthModel(this._store, {String? token}) : _token = token;

  final SecureStore _store;
  String? _token;

  bool busy = false;
  String? error;

  bool get signedIn => _token != null;

  Future<void> login(String email, String password) async {
    if (busy) return;
    busy = true;
    error = null;
    notifyListeners();
    try {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (password.length < 8) {
        error = 'Password must be at least 8 characters';
        return;
      }
      final token = 'tok_${email.hashCode}';
      await _store.saveToken(token);
      _token = token;
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _store.clear();
    _token = null;
    notifyListeners();
  }
}
