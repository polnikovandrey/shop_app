import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/global_constants.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';

class ProductsProvider with ChangeNotifier {
  static const productsCollectionPath = '/products';

  static Uri buildProductsCollectionUri({String? token}) {
    return Uri.https(GlobalConstants.authority, '$productsCollectionPath${GlobalConstants.dotJson}', _buildAuthQueryParameters(token));
  }

  static Uri buildProductIdUri({required String id, String? token}) {
    return Uri.https(GlobalConstants.authority, '$productsCollectionPath/$id/${GlobalConstants.dotJson}', _buildAuthQueryParameters(token));
  }

  static Map<String, String> _buildAuthQueryParameters(String? token) => token == null ? {} : {'auth': token};

  final List<Product> _items;
  final String? _token;
  bool _initialized = false;

  ProductsProvider({List<Product>? items, String? token, bool? initialized})
      : _items = items ?? [],
        _token = token,
        _initialized = initialized ?? false;

  bool get initialized => _initialized;

  List<Product> get items => [..._items];

  List<Product> get favoriteItems => _items.where((product) => product.isFavorite).toList();

  Product findById(String id) => _items.firstWhere((element) => element.id == id);

  Future<void> deleteAllProductsAndSetDummyData() async {
    if (!_initialized) {
      _initialized = true;
      await http.delete(buildProductsCollectionUri(token: _token));
      final List<Future<dynamic>> futures = [];
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
        futures.add(_storeProduct(product));
      }
      await Future.wait(futures);
    }
  }

  Future<void> fetchAndSetProducts() async {
    final products = await _loadProducts();
    _items.clear();
    _items.addAll(products);
    notifyListeners();
  }

  Future<List<Product>> _loadProducts() async {
    final List<Product> loadedProducts = [];
    final response = await http.get(buildProductsCollectionUri(token: _token));
    final extractedData = json.decode(response.body);
    if (response.statusCode == HttpStatus.ok) {
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
    }
    return loadedProducts;
  }

  Future<void> addProduct(Product product) async {
    final response = await _storeProduct(product);
    if (response.statusCode == HttpStatus.ok) {
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
    }
  }

  Future<http.Response> _storeProduct(Product product) async {
    return await http.post(
      buildProductsCollectionUri(token: _token),
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

  Future<void> updateProduct(Product product) async {
    var index = _items.indexWhere((prod) => product.id == prod.id);
    if (index != -1) {
      final uri = buildProductIdUri(id: product.id);
      final response = await http.patch(uri,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          }));
      if (response.statusCode == HttpStatus.ok) {
        _items[index] = product;
        notifyListeners();
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    final existingProductIndex = _items.indexWhere((product) => product.id == id);
    final existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final uri = buildProductIdUri(id: id);
    final response = await http.delete(uri);
    if (response.statusCode != HttpStatus.ok) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete a product');
    }
  }
}
