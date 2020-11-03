import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';
import '../providers/products.dart';

enum FilterOptions { Favorits, All }

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(context, listen: false);
    print('## ProductsOverviewScreen.build()');
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.All)
                productsContainer.showAll();
              else
                productsContainer.showFavoritesOnly();
            },
            // initialValue: FilterOptions.All,
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Show Only Favorites'),
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
      body: ProductsGrid(),
    );
  }
}
