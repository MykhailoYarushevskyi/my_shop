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
  @override
  String toString() {
    return '\nCartItemData: id = $id, title = $title, quantity = $quantity, price = $price\n';
  }

  static CartItemData fromJson(Map<String, dynamic> jsonMap) {
    return CartItemData(
      id: jsonMap['id'],
      title: jsonMap['title'],
      quantity: jsonMap['quantity'],
      price: jsonMap['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "quantity": quantity,
      "price": price,
    };
  }
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
    print('## Cart.addItem() productId: $productId');
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
            id: productId, title: title, quantity: 1, price: price),
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

  void reduceItemQuantity(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingItemData) => CartItemData(
            id: existingItemData.id,
            title: existingItemData.title,
            quantity: existingItemData.quantity - 1,
            price: existingItemData.price),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
