import 'package:flutter/material.dart';

class CartItemData {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItemData({required this.id, required this.productId, required this.title, required this.price, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItemData> _items = {};

  Map<String, CartItemData> get items => {..._items};

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItemData(
          id: existingCartItem.id,
          productId: existingCartItem.productId,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItemData(
          id: DateTime.now().toString(),
          productId: productId,
          title: title,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  int get itemCount => _items.length;

  double get totalAmount => _items.isEmpty ? 0.0 : _items.values.map((item) => item.price * item.quantity).reduce((value, element) => value + element);

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
    notifyListeners();
  }
}
