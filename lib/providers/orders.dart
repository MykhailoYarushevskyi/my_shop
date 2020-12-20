import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:my_shop/models/Exceptions/http_exception.dart';

import '../models/Exceptions/common_Exception.dart';
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

  @override
  String toString() {
    return 'OrderItemData: id = $id, amount = $amount, dateTime = ${dateTime.toString()},\nproducts = $products';
  }
}

class Orders with ChangeNotifier {
  List<OrderItemData> _orders = [];

  List<OrderItemData> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url = 'https://my-shop-1362a-default-rtdb.firebaseio.com/orders.json';
    List<OrderItemData> _loadedOrders = [];

    try {
      final response = await http.get(url);
      // print('## Orders.fetchOrders() response.body: ${response.body}');
      final extructedData = json.decode(response.body) as Map<String, dynamic>;
      extructedData.forEach((orderId, order) {
        _loadedOrders.add(
          OrderItemData(
            id: orderId,
            amount: order["amount"],
            dateTime: DateTime.fromMillisecondsSinceEpoch(order["dateTime"]),
            products: List.generate(
              order["products"].length,
              (index) => CartItemData(
                  id: order["products"][index]['id'],
                  title: order["products"][index]['title'],
                  quantity: order["products"][index]['quantity'],
                  price: order["products"][index]['price']),
            ),
          ),
        );
      });
      _orders = _loadedOrders;
      notifyListeners();
      // print('## Orders.fetchOrders() extructedData: $extructedData');
      // print(
      //     '## Orders.fetchOrders() _orders[${_orders.length - 1}]: ${_orders[_orders.length - 1]}');
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(
    List<CartItemData> cartProducts,
    double total,
  ) async {
    const url = 'https://my-shop-1362a-default-rtdb.firebaseio.com/orders.json';
    if (cartProducts.length <= 0) {
      throw CommonException('Cart is empty');
    }
    final _dateTimeNowMilliswcondsSE = DateTime.now().millisecondsSinceEpoch;
    final _body = json.encode({
      "amount": total,
      "dateTime": _dateTimeNowMilliswcondsSE,
      "products": cartProducts
    });
    print('$_body');
    try {
      final response = await http.post(
        url,
        body: _body,
      );
      //use List.insert(), if we want to insert the element to the start position of the List
      if (response != null && response.statusCode >= 400) {
        throw HttpException('statusCode = ${response.statusCode}');
      }
      _orders.add(
        OrderItemData(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime:
              DateTime.fromMillisecondsSinceEpoch(_dateTimeNowMilliswcondsSE),
        ),
      );
      notifyListeners();
      print('## Orders.addOrder: added ${cartProducts.length} CartItemData');
    } catch (error) {
      throw error;
    }
  }

  void clear() {
    _orders = [];
    notifyListeners();
  }
}
