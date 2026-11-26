import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsModel extends ChangeNotifier {
  SettingsModel(
    this._prefs, {
    required bool dark,
    String? city,
    String? avatarFile,
    required String docsPath,
  }) : _dark = dark,
       _city = city,
       _avatarFile = avatarFile,
       _docsPath = docsPath;

  final SharedPreferencesAsync _prefs;
  final String _docsPath;
  bool _dark;
  String? _city;
  String? _avatarFile;

  bool get dark => _dark;
  String? get city => _city;

  File? get avatar {
    final name = _avatarFile;
    if (name == null) return null;
    final f = File('$_docsPath/$name');
    return f.existsSync() ? f : null;
  }

  Future<void> setDark(bool v) async {
    _dark = v;
    notifyListeners();
    await _prefs.setBool('darkMode', v);
  }

  Future<void> setCity(String? c) async {
    _city = c;
    notifyListeners();
    if (c == null) {
      await _prefs.remove('cityFilter');
    } else {
      await _prefs.setString('cityFilter', c);
    }
  }

  Future<void> setAvatarFile(String name) async {
    _avatarFile = name;
    notifyListeners();
    await _prefs.setString('avatarFile', name);
  }
}
