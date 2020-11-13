import 'package:flutter/foundation.dart';

class CartItemData {
  final String id;
  final String title;
  int quantity;
  final double price;

  CartItemData({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItemData> _items = {};

  Map<String, CartItemData> get items {
    return {..._items};
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItemData) {
      total += cartItemData.price * cartItemData.quantity;
    });
    return total;
  }

  int get itemCount {
    return _items.length;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      // change the quantity:
      // _items[productId].quantity += 1; //works normally
      //          or:
      _items.update(
        productId,
        (existingCartItemData) => CartItemData(
          id: existingCartItemData.id,
          title: existingCartItemData.title,
          price: existingCartItemData.price,
          quantity: existingCartItemData.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItemData(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            price: price),
      );
    }
    notifyListeners();
  }

  void removeItemByItemId(String itemId) {
    _items.removeWhere((key, value) => itemId == value.id);
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
