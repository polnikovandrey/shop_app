import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/orders_provider.dart';

class OrderItem extends StatefulWidget {
  final OrderItemData _orderItemData;

  const OrderItem({required OrderItemData orderItemData, Key? key})
      : _orderItemData = orderItemData,
        super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final products = widget._orderItemData.products;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: _expanded ? min(products.length * 20 + 110, 200) : 95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget._orderItemData.amount.toStringAsFixed(2)}'),
              subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget._orderItemData.dateTime)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () => setState(() => _expanded = !_expanded),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  height: _expanded ? min(products.length * 20 + 10, 100) : 0,
                  child: LimitedBox(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (ctx, index) {
                        var cartItemData = products[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cartItemData.title,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${cartItemData.quantity} x \$${cartItemData.price}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
