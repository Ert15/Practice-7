import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('badge build');

    // select = "rebuild me only when THIS number changes".
    // For the Level 4 measurement, temporarily swap it for:
    //   final n = context.watch<Cart>().count;
    final n = context.select<Cart, int>((c) => c.count);

    return IconButton(
      onPressed: () => Navigator.of(context).pushNamed('/cart'),
      icon: Badge(
        label: Text('$n'),
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
