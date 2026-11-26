import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../settings/settings_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _say(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _chooseFromGallery() => _pick(ImageSource.gallery);

  Future<void> _takePhoto() async {
    final status = await Permission.camera.request();
    if (!mounted) return;
    switch (status) {
      case PermissionStatus.granted:
        await _pick(ImageSource.camera);
      case PermissionStatus.denied:
        _say('The camera is needed to take a photo. You can try again.');
      case PermissionStatus.permanentlyDenied:
        final go = await showDialog<bool>(
          context: context,
          builder: (_) => const CameraOffDialog(),
        );
        if (go == true) await openAppSettings();
      case PermissionStatus.restricted ||
          PermissionStatus.limited ||
          PermissionStatus.provisional:
        _say('Camera access is restricted on this device.');
    }
  }

  Future<void> _pick(ImageSource source) async {
    final settings = context.read<SettingsModel>();
    final XFile? shot;
    try {
      shot = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1024,
        imageQuality: 85,
      );
    } on PlatformException {
      if (mounted) _say('Could not open the camera or gallery.');
      return;
    }
    if (shot == null || !mounted) return;

    final docs = await getApplicationDocumentsDirectory();
    final target = File('${docs.path}/avatar.jpg');
    await File(shot.path).copy(target.path);
    await FileImage(target).evict();
    await settings.setAvatarFile('avatar.jpg');
  }

  @override
  Widget build(BuildContext context) {
    final photo = context.watch<SettingsModel>().avatar;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: photo == null ? null : FileImage(photo),
              child: photo == null ? const Text('U') : null,
            ),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: _chooseFromGallery,
              child: const Text('Choose photo'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _takePhoto,
              child: const Text('Take photo'),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraOffDialog extends StatelessWidget {
  const CameraOffDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Camera is off'),
    content: const Text(
      'To take a photo, allow the camera in the app settings. '
      'You can still choose a photo from the gallery.',
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text('Not now'),
      ),
      FilledButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: const Text('Open settings'),
      ),
    ],
  );
}
