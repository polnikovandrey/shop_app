import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/orders_provider.dart';

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final CartProvider cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _isLoading || widget.cart.totalAmount <= 0
          ? null
          : () async {
              setState(() => _isLoading = true);
              await Provider.of<OrdersProvider>(context, listen: false).addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);
              setState(() => _isLoading = false);
              widget.cart.clear();
            },
      child: _isLoading ? const CircularProgressIndicator() : const Text('Order Now'),
    );
  }
}
