import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  factory Product.fromJson({
    String id,
    Map<String, dynamic> jsonMap,
  }) =>
      Product(
        id: id,
        title: jsonMap['title'],
        price: double.parse(jsonMap['price'].toString()),
        description: jsonMap['description'],
        imageUrl: jsonMap['imageUrl'],
        isFavorite: jsonMap['isFavorite'],
      );

  @override
  String toString() {
    return '${super.toString()}: id: $id, title: $title, description: $description, price: $price, imageUrl: $imageUrl, isFavorite: $isFavorite';
  }
}
