import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../screens/cart_screen.dart';

enum FilterOptions {
  Favorits,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const String routeName = '/';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    print('## ProductsOverviewScreen.build()');
    // final cart = context.watch<Cart>();
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (context, cart, childWidget) {
              // print('## ProductsOverviewScreen cart.itemCount = ${cart.itemCount}');
              return Badge(
                // key: Key('123'),
                value: cart.itemCount.toString(),
                child: childWidget,
              );
            },
            //it will childWidget in builder:
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.pushNamed(context, CartScreen.routeName),
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorits) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            // initialValue: FilterOptions.All,
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorits,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: FilterOptions.All,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
      drawer: AppDrawer(),
    );
  }
}
