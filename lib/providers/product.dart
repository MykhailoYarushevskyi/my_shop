import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import '../models/Exceptions/http_exception.dart';

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

  Future<void> toggleFavoriteStatus(
    String authToken,
    String userId,
  ) async {
    final url =
        'https://my-shop-1362a-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(
        url,
        body: json.encode(isFavorite), // or isFavorite.toString
        // body: json.encode({'isFavorite': isFavorite}),
      );
      if (response.statusCode >= 400) {
        throw HttpException('status code = ${response.statusCode}');
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
      throw error;
    }
  }

  factory Product.fromJson({
    String id,
    bool isUserFavorite,
    Map<String, dynamic> jsonMap,
  }) =>
      Product(
        id: id,
        title: jsonMap['title'],
        price: double.parse(jsonMap['price'].toString()),
        description: jsonMap['description'],
        imageUrl: jsonMap['imageUrl'],
        // isFavorite: jsonMap['isFavorite'],
        isFavorite: isUserFavorite,
      );

  @override
  String toString() {
    return '${super.toString()}: id: $id, title: $title, description: $description, price: $price, imageUrl: $imageUrl, isFavorite: $isFavorite';
  }
}
