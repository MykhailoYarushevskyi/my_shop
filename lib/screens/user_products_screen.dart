import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/user-products-creen';
  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    final productsData = context.watch<Products>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Your products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 28,
            onPressed: () => Navigator.of(context).pushNamed(
              EditProductScreen.routeName,
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (context, index) => Column(
            children: [
              UserProductItem(
                id: productsData.items[index].id,
                title: productsData.items[index].title,
                imageUrl: productsData.items[index].imageUrl,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
