import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products_overview';

  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop App'),
        actions: [
          PopupMenuButton(
            onSelected: (value) => setState(() => _showOnlyFavorites = value == FilterOptions.favorites),
            icon: const Icon(Icons.more_vert),
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: FilterOptions.favorites,
                child: Text('Only Favorites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Show All'),
              )
            ],
          ),
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) => Badge(
              value: cartProvider.itemCount.toString(),
              child: child,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
          ),
        ],
      ),
      body: ProductsGrid(showOnlyFavorites: _showOnlyFavorites),
    );
  }
}
