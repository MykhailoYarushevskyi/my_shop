import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../providers/orders.dart';
import '../providers/cart.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = '/cart-screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isActive = true;
  var _isLoading = false;

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

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    // _isLoading = false;
    if (cart.items.values.toList().length == 0) {
      _isActive = false;
    } else {
      _isActive = true;
    }
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
                    builder: (context) => FlatButton(
                      textColor: _isActive && !_isLoading
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor,
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Text('ORDER NOW'),
                      onPressed: () {
                        // Provider.of<Orders>(context, listen: false).addOrder(cartproducts, total);
                        //               or
                        if (cart.items.values.toList().length > 0) {
                          setState(() {
                            _isLoading = true;
                          });
                          context
                              .read<Orders>()
                              .addOrder(
                                cart.items.values.toList(),
                                cart.totalAmount,
                              )
                              .then((_) {
                            setState(() {
                              _isLoading = false;
                            });
                            cart.clear();
                            showMessage(context,
                                message: 'Cart added to orders',
                                textColor:
                                    Theme.of(context).textTheme.headline6.color,
                                seconds: Duration(seconds: 2));
                          }).catchError((error) {
                            showDialog(
                              context: context,
                              child: AlertDialog(
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
                        } else
                          // calling showSnackBar():
                          showMessage(context,
                              message:
                                  'Your сart is EMPTY. Please, fill up your сart.',
                              textColor: Theme.of(context).errorColor,
                              seconds: Duration(seconds: 2));
                      },
                    ),
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
