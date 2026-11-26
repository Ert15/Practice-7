import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:kbtu_flutter1projek/core/storage/secure_store.dart';
import 'package:kbtu_flutter1projek/features/auth/auth_model.dart';
import 'package:kbtu_flutter1projek/features/auth/login_screen.dart';

void main() {
  testWidgets('shows the login form', (tester) async {
    final store = SecureStore();
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthModel(store),
        child: const MaterialApp(home: LoginScreen()),
      ),
    );

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });
}
