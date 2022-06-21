import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart' show CartProvider;
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(
                      '${cart.totalAmount}',
                      style: Theme.of(context).primaryTextTheme.bodyMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<OrdersProvider>(context, listen: false).addOrder(cart.items.values.toList(), cart.totalAmount);
                      cart.clear();
                    },
                    child: const Text('Order Now'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, index) {
                var cartItem = cart.items.values.toList()[index];
                return ci.CartItem(
                  id: cartItem.id,
                  productId: cartItem.productId,
                  title: cartItem.title,
                  price: cartItem.price,
                  quantity: cartItem.quantity,
                  key: ValueKey(cartItem.id),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
