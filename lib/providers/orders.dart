import 'package:flutter/foundation.dart';
import './cart.dart';

class OrderItemData {
  final String id;
  final double amount;
  final List<CartItemData> products;
  final DateTime dateTime;

  OrderItemData({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItemData> _orders = [];

  List<OrderItemData> get orders {
    return [..._orders];
  }

  void addOrder(
    List<CartItemData> cartProducts,
    double total,
  ) {
    //use List.insert(), if we want to insert the element to the start position of the List
    if (cartProducts.length > 0) {
      _orders.insert(
        0,
        OrderItemData(
          id: DateTime.now().toString(),
          amount: total,
          products: cartProducts,
          dateTime: DateTime.now(),
        ),
      );
      notifyListeners();
      print('## Orders.addOrder: added ${cartProducts.length} CartItemData');
    }
  }

  void clear() {
    _orders = [];
    notifyListeners();
  }
}
