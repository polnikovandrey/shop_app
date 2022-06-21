import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart_provider.dart';

class OrdersProvider with ChangeNotifier {

  final List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItemData> cartProducts, double total) {
    _orders.insert(0, OrderItem(id: DateTime.now().toString(), amount: total, products: cartProducts, dateTime: DateTime.now()));
    notifyListeners();
  }
}

class OrderItem {

  final String id;
  final double amount;
  final List<CartItemData> products;
  final DateTime dateTime;

  OrderItem({required this.id, required this.amount, required this.products, required this.dateTime});
}
