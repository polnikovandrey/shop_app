import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/uri_generator.dart';

class OrdersProvider with ChangeNotifier {
  final List<OrderItemData> _orders;
  final String? _token;
  final String? _userId;

  OrdersProvider({List<OrderItemData>? orders, String? token, String? userId})
      : _orders = orders ?? [],
        _token = token,
        _userId = userId;

  List<OrderItemData> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final List<OrderItemData> loadedOrders = [];
    final response = await http.get(UriGenerator.buildOrdersCollectionUri(_token, _userId));
    final extractedData = json.decode(response.body);
    if (extractedData != null) {
      extractedData.forEach((id, order) {
        loadedOrders.add(
          OrderItemData(
            id: id,
            amount: order['amount'],
            products: (order['products'] as List<dynamic>)
                .map((cartItemJson) => CartItemData(
                      id: cartItemJson['id'],
                      productId: cartItemJson['productId'],
                      title: cartItemJson['title'],
                      price: cartItemJson['price'],
                      quantity: cartItemJson['quantity'],
                    ))
                .toList(),
            dateTime: DateTime.parse(order['dateTime']),
          ),
        );
      });
    }
    _orders.clear();
    _orders.addAll(loadedOrders.reversed);
    notifyListeners();
  }

  Future<void> addOrder(List<CartItemData> cartProducts, double amount) async {
    final timestamp = DateTime.now();
    final response = await http.post(UriGenerator.buildOrdersCollectionUri(_token, _userId),
        body: json.encode({
          'amount': amount,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cartProduct) => {
                    'id': cartProduct.id,
                    'productId': cartProduct.productId,
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
