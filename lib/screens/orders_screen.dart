import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    final ordersData = context.watch<Orders>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (context, index) => OrderItem(ordersData.orders[index]),
      ),
    drawer: AppDrawer(),);
  }
}
