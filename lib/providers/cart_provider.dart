import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem {
  final String id;
  final Product product;
  final int quantity;

  CartItem({required this.id, required this.product, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(product.id, (ex) => CartItem(id: ex.id, product: ex.product, quantity: ex.quantity + 1));
    } else {
      _items.putIfAbsent(product.id, () => CartItem(id: DateTime.now().toString(), product: product));
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items.update(productId, (ex) => CartItem(id: ex.id, product: ex.product, quantity: ex.quantity - 1));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}