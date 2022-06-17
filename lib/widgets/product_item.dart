import 'package:flutter/material.dart';
import 'package:shop_app/models/product.dart';

class ProductItem extends StatelessWidget {
  final Product _product;

  const ProductItem(this._product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        leading: IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: () {},
        ),
        trailing: IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {},
        ),
        title: Text(
          _product.title,
          textAlign: TextAlign.center,
        ),
      ),
      child: Image.network(
        _product.imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
