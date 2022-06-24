import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  final String _id;
  final String _productId;
  final String _title;
  final double _price;
  final int _quantity;

  const CartItem({required String id, required String productId, required String title, required double price, required int quantity, Key? key})
      : _id = id,
        _productId = productId,
        _title = title,
        _price = price,
        _quantity = quantity,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(_id),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to remove the item from the cart?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      ),
      onDismissed: (direction) => Provider.of<CartProvider>(context, listen: false).removeItem(_productId),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$${_price.toStringAsFixed(2)}'),
                ),
              ),
            ),
            title: Text(_title),
            subtitle: Text('Total: \$${(_price * _quantity).toStringAsFixed(2)}'),
            trailing: Text('$_quantity x'),
          ),
        ),
      ),
    );
  }
}
