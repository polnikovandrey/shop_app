import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/orders_provider.dart';

class OrderItem extends StatelessWidget {
  final OrderItemData _orderItemData;

  const OrderItem({required OrderItemData orderItemData, Key? key})
      : _orderItemData = orderItemData,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${_orderItemData.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(_orderItemData.dateTime)),
            trailing: IconButton(
              icon: const Icon(Icons.expand_more),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
