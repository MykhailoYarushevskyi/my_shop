import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = '/orders-screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      context.read<Orders>().fetchAndSetOrders().then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          child: AlertDialog(
            actions: [
              FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    // setState(() {
                    //   _isLoading = false;
                    // });
                    Navigator.of(context).pop();
                  }),
            ],
            title: Text(
              'An Error occured!',
              style: TextStyle(
                color: Theme.of(context).errorColor,
                fontSize: 20,
              ),
            ),
            content: Text(
                'Something go wrong.\nMay be unavailable an internet connection'),
          ),
        );
      }).whenComplete(() => setState(() {
            _isLoading = false;
          }));
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = context.watch<Orders>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: ordersData.orders.length,
              itemBuilder: (context, index) =>
                  OrderItem(ordersData.orders[index]),
            ),
      drawer: AppDrawer(),
    );
  }
}
