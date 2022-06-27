import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/user-products';

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: productsProvider.fetchAndSetProducts(true),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => productsProvider.fetchAndSetProducts(true),
                child: Consumer<ProductsProvider>(
                  builder: (context, productsProvider, child) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: productsProvider.items.length,
                      itemBuilder: (ctx, index) {
                        var product = productsProvider.items[index];
                        return UserProductItem(
                          id: product.id,
                          title: product.title,
                          imageUrl: product.imageUrl,
                          key: ValueKey(product.id),
                        );
                      },
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
