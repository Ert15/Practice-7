// Only foundation.dart: this file knows nothing about widgets.
import 'package:flutter/foundation.dart';

import 'book.dart';

class Cart extends ChangeNotifier {
  // Private: outside code cannot touch it directly.
  // Key = the book, value = how many copies.
  final Map<Book, int> _qty = {};

  // A read-only copy. cart.items.add(...) throws an error.
  List<Book> get items => List.unmodifiable(_qty.keys);

  // How many DIFFERENT books are in the cart.
  int get count => _qty.length;

  // Price x quantity for every book, summed up.
  int get total =>
      _qty.entries.fold(0, (sum, e) => sum + e.key.price * e.value);

  int qtyOf(Book b) => _qty[b] ?? 0;

  // The rule "no duplicates" lives HERE and nowhere else.
  // Returns false (and does nothing) if the book is already in the cart.
  bool add(Book b) {
    if (_qty.containsKey(b)) return false;
    _qty[b] = 1;
    notifyListeners();
    return true;
  }

  void remove(Book b) {
    _qty.remove(b);
    notifyListeners();
  }

  void increment(Book b) {
    if (!_qty.containsKey(b)) return;
    _qty[b] = _qty[b]! + 1;
    notifyListeners();
  }

  void clear() {
    _qty.clear();
    notifyListeners();
  }
}
