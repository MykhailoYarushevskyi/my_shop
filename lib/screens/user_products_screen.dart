import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/user-products-creen';

  Future<void> _refreshProducts(BuildContext context) async {
    print('## UserProductsScreen - Entrance into _refreshProducts()');
    // !!! when _refreshProducts() was called as callback onRefresh in RefreshIndicator()
    // all go well.
    // !!! But when it was called as a 'future' parameter of the FutureBuilder(),
    // after context.read<Products>() it does not further go neither 
    // in then() method nor in catchError() method.
    // await context.read<Products>()
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(filterByUser: true)
        .then((_) {
      print('## UserProductsScreen._refreshProducts()-> products.fetchAndSetProducts(filterByUser: true) then() block');
    }).catchError((error) {
      print('## UserProductsScreen._refreshProducts() -> products.fetchAndSetProducts(filterByUser: true) catchError() block');
      showDialog(
        context: context,
        builder: (contect) => AlertDialog(
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Ok'),
            )
          ],
          title: Text(
            'An Error occured!',
            style: TextStyle(
              color: Theme.of(context).errorColor,
              fontSize: 20,
            ),
          ),
          titlePadding: EdgeInsets.all(10),
          content: Text(
              'Something go wrong.\nMay be unavailable an internet connection'),
        ),
      );
    });
    print('## UserProductsScreen - EXIT from _refreshProducts()');
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    //   or:
    // statement below changed to Consumer() to avoid an infinite loop
    // with FutureBuilder
    // final productsData = context.watch<Products>();
    print('## UserProductsScreen.build() Entrance');
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
      body: FutureBuilder(
          //fetch data when this first loads, when this first builds
          future: _refreshProducts(context),
          builder: (context, snapshot) {
            print(
              '## UserProductsScreen - FutureBuilder()->builder snapshot.connectionState: ${snapshot.connectionState}',
            );
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: Consumer<Products>(
                builder: (context, productsData, child) => Padding(
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
              ),
            );
          }),
    );
  }
}
