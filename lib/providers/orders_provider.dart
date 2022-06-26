import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/global_constants.dart';
import 'package:shop_app/providers/cart_provider.dart';

class OrdersProvider with ChangeNotifier {
  static const ordersCollectionPath = '/orders';
  static final ordersCollectionUri = Uri.https(GlobalConstants.authority, '$ordersCollectionPath${GlobalConstants.dotJson}');

  final List<OrderItemData> _orders = [];

  List<OrderItemData> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItemData> cartProducts, double amount) async {
    final timestamp = DateTime.now();
    final response = await http.post(ordersCollectionUri,
        body: json.encode({
          'amount': amount,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cartProduct) => {
                    'id': cartProduct.id,
                    'title': cartProduct.title,
                    'quantity': cartProduct.quantity,
                    'price': cartProduct.price,
                  })
              .toList(),
        }));
    _orders.insert(0, OrderItemData(id: json.decode(response.body)['name'], amount: amount, products: cartProducts, dateTime: timestamp));
    notifyListeners();
  }
}

class OrderItemData {
  final String id;
  final double amount;
  final List<CartItemData> products;
  final DateTime dateTime;

  OrderItemData({required this.id, required this.amount, required this.products, required this.dateTime});
}
