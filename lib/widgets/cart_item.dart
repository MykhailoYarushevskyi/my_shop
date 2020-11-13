import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String productId;
  CartItem({
    this.id,
    this.title,
    this.price,
    this.quantity,
    this.productId
  });
  @override
  Widget build(BuildContext context) {
    // final cart = context.watch<Cart>();
    //                or
    // final cart = Provider.of<Cart>(context);
    return Dismissible(
      onDismissed: (dismissdirection) {
        context.read<Cart>().removeItem(productId);
        // or:
        // context.read<Cart>().removeItemByItemId(id);
      },
      key: ValueKey(id),
      background: Container(
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: FittedBox(
                  // fit: BoxFit.scaleDown,
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
