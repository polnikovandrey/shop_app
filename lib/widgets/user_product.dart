import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String _id;
  final String _title;
  final String _imageUrl;

  const UserProductItem({required String id, required String title, required String imageUrl, Key? key})
      : _id = id,
        _title = title,
        _imageUrl = imageUrl,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(_title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(_imageUrl),
          ),
          trailing: SizedBox(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () => Navigator.of(context).pushNamed(
                    EditProductScreen.routeName,
                    arguments: _id,
                  ),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  color: Theme.of(context).colorScheme.error,
                  onPressed: () => Provider.of<ProductsProvider>(context, listen: false).deleteProduct(_id),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
