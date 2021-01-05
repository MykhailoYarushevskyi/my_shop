import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './providers/products.dart';
import './providers/orders.dart';
import './providers/cart.dart';
import './providers/auth.dart';
import './screens/error_content_screen.dart';
import './screens/splash_screen.dart';
import './screens/auth_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // static const String initialRoute = '/';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        // ChangeNotifierProvider(create: (context) => Products()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: null,
          update: (context, auth, previosProducts) => Products(
            auth.token,
            auth.userId,
            previosProducts == null ? [] : previosProducts.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: null,
          update: (context, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
        ChangeNotifierProvider(create: (context) => Cart()),
        // it is possible to use a .value() constructor, it works, but
        // the approach above is better and recommended.
        // ChangeNotifierProvider<Orders>.value(
        //   value: Orders(),),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'My Shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
/*           home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ), */
          initialRoute: '/',
          routes: {
            '/': (context) => auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (
                      context,
                      authResultSnapshot,
                    ) 
                    // {
                      // auth
                      //     .tryAutoLogin()
                      //     .then((value) => print(
                      //         '## MyApp auth.tryAutoLogin().then($value)'))
                      //     .catchError((error) => print(
                      //         '## MyApp auth.tryAutoLogin().catchError($error)'));
                      // print(
                      //     '## MyApp FutureBuilder() authResultSnapshot.connectionState: ${authResultSnapshot.connectionState}');
                      // print(
                      //     '## MyApp FutureBuilder() authResultSnapshot.data: ${authResultSnapshot.data}');
                      // print(
                      //     '## MyApp FutureBuilder() auth.isAuth: ${auth.isAuth}; auth.UserId: ${auth.userId}; auth.token: ${auth.token}');
                      // return authResultSnapshot.connectionState ==
                      => authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()
                    // }
                    ),
            AuthScreen.routeName: (context) => AuthScreen(),
            ProductsOverviewScreen.routeName: (context) =>
                ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
            ErrorContentScreen.routeName: (context) => ErrorContentScreen(),
          },
        ),
      ),
    );
  }
}
