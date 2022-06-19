import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String _id;
  final String _title;
  final double _price;
  final int _quantity;

  const CartItem({required String id, required String title, required double price, required int quantity, Key? key})
      : _id = id,
        _title = title,
        _price = price,
        _quantity = quantity,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
