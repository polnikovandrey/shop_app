import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/products_provider.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final uri = ProductsProvider.buildProductIdUri(id);
    try {
      final response = await http.patch(uri, body: json.encode({'isFavorite': isFavorite}));
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException('Could not make a product favorite');
      }
    } catch(exception) {
      isFavorite = oldStatus;
      notifyListeners();
      rethrow;
    }
  }
}
