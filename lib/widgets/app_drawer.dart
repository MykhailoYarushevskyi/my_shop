import 'dart:ui';

import 'package:flutter/material.dart';
import '../screens/orders_screen.dart';
import '../screens/products_overview_screen.dart';

class AppDrawer extends StatelessWidget {
  Widget _buildListTile({
    IconData iconData,
    String title,
    Function tapHandler,
  }) {
    return ListTile(
      leading: Icon(
        iconData,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w700,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          // Container(
          //   color: Colors.black12,
          //   width: double.infinity,
          //   height: 100,
          //   padding: EdgeInsets.all(10),
          //   alignment: Alignment.center,
          //   child: Text(
          //     'SHOP Application',
          //     style: TextStyle(
          //         color: Theme.of(context).accentColor,
          //         fontSize: 24,
          //         fontFamily: 'Lato',
          //         fontWeight: FontWeight.bold),
          //   ),
          // ),
          //             === or ===
          // AppBar(
          //   title: Text('Welcome to Shop'),
          //   centerTitle: true,
          //   automaticallyImplyLeading: false,
          // ),
          //              === or ===
          DrawerHeader(
            curve: Curves.fastOutSlowIn,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                'Welcome to Shop',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: 24,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            duration: Duration(seconds: 1),
          ),
          // Divider(
          //   thickness: 3,
          // ),
          _buildListTile(
            iconData: Icons.shopping_basket,
            title: 'Shop',
            tapHandler: () => Navigator.of(context).pushReplacementNamed(
              ProductsOverviewScreen.routeName,
            ),
          ),
          Divider(
            thickness: 3,
          ),
          _buildListTile(
            iconData: Icons.payment,
            // iconData: Icons.list_rounded,
            title: 'Orders',
            tapHandler: () => Navigator.of(context).pushReplacementNamed(
              OrdersScreen.routeName,
            ),
          ),
          Divider(
            thickness: 3,
          ),
        ],
      ),
    );
  }
}
