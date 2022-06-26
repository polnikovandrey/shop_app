import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture = Future.value(null);

  Future _obtainOrdersFuture() {
    return Provider.of<OrdersProvider>(context, listen: false).fetchAndSetOrders();
  }


  @override
  void initState() {
    super.initState();
    _ordersFuture = _obtainOrdersFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (dataSnapshot.error != null) {
            return const Center(child: Text('An error occurred'));
          } else {
            return Consumer<OrdersProvider>(builder: (ctx, ordersProvider, child) => ListView.builder(
              itemCount: ordersProvider.orders.length,
              itemBuilder: (ctx, index) {
                final orderItemData = ordersProvider.orders[index];
                return OrderItem(orderItemData: orderItemData, key: ValueKey(orderItemData.id));
              },
            ));
          }
        },
      ),
    );
  }
}
