import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shop_app/providers/product.dart';

class ProductsProvider with ChangeNotifier {
  static final productsUri = Uri.https('flutter-shop-app-cfa87-default-rtdb.asia-southeast1.firebasedatabase.app', '/products.json');

  final List<Product> _items = [];

  List<Product> get items => [..._items];

  List<Product> get favoriteItems => _items.where((product) => product.isFavorite).toList();

  Product findById(String id) => _items.firstWhere((element) => element.id == id);

  Future<void> fetchAndSetProducts() async {
    await http.delete(productsUri);
    for (var product in [
      Product(
        id: '',
        title: 'Red Shirt',
        description: 'A red shirt - it is pretty red!',
        price: 29.99,
        imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      ),
      Product(
        id: '',
        title: 'Trousers',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
      ),
      Product(
        id: '',
        title: 'Yellow Scarf',
        description: 'Warm and cozy - exactly what you need for the winter.',
        price: 19.99,
        imageUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
      ),
      Product(
        id: '',
        title: 'A Pan',
        description: 'Prepare any meal you want.',
        price: 49.99,
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
      ),
    ]) {
      await _storeProduct(product);
    }
    final products = await _loadProducts();
    _items.clear();
    _items.addAll(products);
    notifyListeners();
  }

  Future<List<Product>> _loadProducts() async {
    final response = await http.get(productsUri);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<Product> loadedProducts = [];
    extractedData.forEach((key, value) {
      final productId = key;
      final productData = value;
      loadedProducts.add(Product(
        id: productId,
        title: productData['title'],
        description: productData['description'],
        price: productData['price'],
        imageUrl: productData['imageUrl'],
        isFavorite: productData['isFavorite'],
      ));
    });
    return loadedProducts;
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await _storeProduct(product);
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
      );
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<Response> _storeProduct(Product product) async {
    return await http.post(
      productsUri,
      body: json.encode(
        {
          "title": product.title,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        },
      ),
    );
  }

  void updateProduct(Product product) {
    var index = _items.indexWhere((prod) => product.id == prod.id);
    if (index != -1) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
