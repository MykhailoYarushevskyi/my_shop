import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../screens/cart_screen.dart';
import './error_content_screen.dart';

enum FilterOptions {
  Favorits,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const String routeName = '/products-overview';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    print('## _ProductsOverviewScreenState.initState()');
    // context.read<Products>().fetchAndSetProducts(); //This work here
    // Provider.of<Products>(context, listen: false).fetchAndSetProducts();//This work here
    // context.watch<Products>().fetchAndSetProducts();//This does not work here
    // Provider.of<Products>(context).fetchAndSetProducts(); //This does not work here
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      context
          .read<Products>()
          .fetchAndSetProducts()
          .then((value) => setState(() {
                _isLoading = false;
              }))
          .catchError((error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            scrollable: true,
            actions: [
              // Text('In more detail:'),
              FlatButton(
                child: Icon(Icons.help),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    ErrorContentScreen.routeName,
                    arguments: error.toString(),
                  );
                },
              ),
              FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.of(context).pop();
                  }),
            ],
            title: Text(
              'An Error occured!',
              style: TextStyle(
                color: Theme.of(context).errorColor,
                fontSize: 20,
              ),
            ),
            content: Text('Something go wrong.'),
          ),
        );
      });
      // Provider.of<Products>(context).fetchAndSetProducts();This work here
      //Tried to use `context.watch<Products>` outside of the `build` method or `update` callback of a provider.

      //For context.watch<Products>() throw an ERROR:This is likely a mistake,
      //as it doesn't make sense to rebuild a widget when the value obtained
      //changes, if that value is not used to build other widgets.
      //Consider using `context.read<Products> instead.
      // context.watch<Products>().fetchAndSetProducts();//This does not work here
    }
    _isInit = false;
  }

  Future<void> refreshProducts(BuildContext context) async {
    await context
        .read<Products>()
        .fetchAndSetProducts()
        .then((_) {})
        .catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          scrollable: true,
          actions: [
            // Text('In more detail:'),
            FlatButton(
              child: Icon(Icons.help),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  ErrorContentScreen.routeName,
                  arguments: error.toString(),
                );
              },
            ),
            FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.of(context).pop();
                }),
          ],
          title: Text(
            'An Error occured!',
            style: TextStyle(
              color: Theme.of(context).errorColor,
              fontSize: 20,
            ),
          ),
          content: Text('Something go wrong.'),
        ),
      );
    });
  }

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
            //This will the childWidget as argument of the anonymous function of the builder:
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
      body: RefreshIndicator(
        onRefresh: () => refreshProducts(context),
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20.0),
                    Text(
                      'Loading ...',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              )
            : ProductsGrid(_showOnlyFavorites),
      ),
      drawer: AppDrawer(),
    );
  }
}
