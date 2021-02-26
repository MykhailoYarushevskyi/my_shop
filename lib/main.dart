import 'package:flutter/material.dart';
import 'package:my_shop/helpers/custom_route.dart';

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
        
        // ! look there:
        //https://pub.dev/documentation/provider/latest/provider/ChangeNotifierProxyProvider-class.html

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
        // the approach above is better and recommended.
        // it is possible to use a .value() constructor, it works, but 
        // strongly not recommended here.
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
            //we actually have that fade transition for every
            //route change and if we go to the 'shop' or to the 'orders' or back to the 'shop',
            //we always have this FadeTransition. So this is how we could change 
            //the transition for all our routes if we wanted to, here through 
            //the theme  with the help of the PageTransitionTheme and our own 
            //PageTransitionBuilder (CustomPageTransitionBuilder) which is very 
            //similar to our own CustomRoute here, difference is we have one 
            //extra argument in buildTransitions() method here and we use it for
            //different purposes. CustomRoute here for single routes on the fly
            //creation, CustomPageTransitionBuilder here for a general theme 
            //which affects all route transitions
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            }),
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
                        =>
                        authResultSnapshot.connectionState ==
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
