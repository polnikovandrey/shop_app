import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/user-products';

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: products.items.length,
          itemBuilder: (ctx, index) {
            var product = products.items[index];
            return UserProductItem(
              title: product.title,
              imageUrl: product.imageUrl,
              key: ValueKey(product.id),
            );
          },
        ),
      ),
    );
  }
}
