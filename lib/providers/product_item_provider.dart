import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/auth_exception.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/uri_generator.dart';

class ProductItemProvider with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ProductItemProvider({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus({String? userId, String? token}) async {
    if (userId == null || token == null) {
      throw AuthException.unauthorizedAccess();
    }
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final Uri uri = UriGenerator.buildUserFavoritesUserIdProductIdUri(userId: userId, productId: id, token: token);
    try {
      final response = await http.put(uri, body: json.encode(isFavorite));
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException('Could not make a product favorite');
      }
    } catch (exception) {
      isFavorite = oldStatus;
      notifyListeners();
      rethrow;
    }
  }
}
