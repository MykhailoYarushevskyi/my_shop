import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../providers/orders.dart';
import '../providers/cart.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total', style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6.color,
                      ),
                    ),
                  ),
                  Builder(
                    //using Builder for correct work of the Scaffold.of(context)
                    builder: (context) => OrderButton(cart: cart),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => CartItem(
                id: cart.items.values.toList()[index].id,
                title: cart.items.values.toList()[index].title,
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
                productId: cart.items.keys.toList()[index],
              ),
              itemCount: cart.items.length,
            ),
          )
        ],
      ),
    );
  }

  void showMessageByModalBottomSheet(
    BuildContext context, {
    String message = '',
    Color textColor = Colors.black,
    Duration duration,
  }) async {
    if (duration.inMilliseconds < 0 || duration == null)
      duration = Duration(seconds: 1);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 50,
            margin: EdgeInsets.only(
              top: 5,
              left: 10,
              right: 10,
            ),
            padding: EdgeInsets.all(10),
            color: Theme.of(context).backgroundColor,
            child: Center(
              child: FittedBox(
                child: Text(
                  message,
                  style: TextStyle(color: textColor, fontSize: 20),
                ),
              ),
            ),
          );
        });
    await Future.delayed(duration);
    Navigator.of(context).pop();
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  void showMessage(
    BuildContext context, {
    String message = '',
    Color textColor = Colors.black,
    Duration seconds,
  }) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Container(
          height: 50,
          margin: EdgeInsets.only(
            top: 5,
            left: 10,
            right: 10,
          ),
          padding: EdgeInsets.all(10),
          color: Theme.of(context).backgroundColor,
          child: Center(
            child: FittedBox(
              child: Text(
                message,
                style: TextStyle(color: textColor, fontSize: 20),
              ),
            ),
          ),
        ),
        duration: seconds,
      ),
    );
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      textColor: Theme.of(context).primaryColor,
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Text('ORDER NOW'),
      //if onPressed is null, Button will disable
      onPressed: (widget.cart.items.values.toList().length <= 0) || _isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              // Provider.of<Orders>(context, listen: false).addOrder(cartproducts, total);
              //           or
              await context
                  .read<Orders>()
                  .addOrder(
                    widget.cart.items.values.toList(),
                    widget.cart.totalAmount,
                  )
                  .then((_) {
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clear();
                showMessage(context,
                    message: 'Cart added to orders',
                    textColor: Theme.of(context).textTheme.headline6.color,
                    seconds: Duration(seconds: 2));
              }).catchError((error) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    actions: [
                      FlatButton(
                          child: Text('Ok'),
                          onPressed: () {
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
                setState(() {
                  _isLoading = false;
                });
              });
            },
    );
  }
}
