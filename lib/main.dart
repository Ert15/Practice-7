import 'package:flutter/material.dart';

import 'countdown_screen.dart';
import 'students_future_screen.dart';
import 'students_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'students_async',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice 10')),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OpenButton(label: 'By hand', screen: StudentsScreen()),
            OpenButton(label: 'FutureBuilder', screen: StudentsFutureScreen()),
            OpenButton(label: 'Countdown', screen: CountdownScreen()),
          ],
        ),
      ),
    );
  }
}

class OpenButton extends StatelessWidget {
  const OpenButton({super.key, required this.label, required this.screen});

  final String label;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: FilledButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (_) => screen),
        ),
        child: Text(label),
      ),
    );
  }
}
