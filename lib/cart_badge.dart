import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('badge build');

    final n = context.select<Cart, int>((c) => c.count);

    return IconButton(
      onPressed: () => Navigator.of(context).pushNamed('/cart'),
      icon: Badge(
        label: Text(
          '$n',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
        child: const Icon(Icons.shopping_cart, color: Colors.black),
      ),
    );
  }
}
