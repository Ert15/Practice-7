import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'books_screen.dart';
import 'cart_screen.dart';
import 'models/cart.dart';

// The Cart is put into the tree ONCE, above MaterialApp.
void main() => runApp(
      ChangeNotifierProvider(
        create: (_) => Cart(),
        child: const Shell(),
      ),
    );

// No list, no callbacks, no setState any more.
class Shell extends StatelessWidget {
  const Shell({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        ),
        routes: {
          '/': (_) => const BooksScreen(),
          '/cart': (_) => const CartScreen(),
        },
      );
}
