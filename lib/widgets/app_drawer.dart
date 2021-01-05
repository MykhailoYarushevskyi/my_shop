import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/products_overview_screen.dart';

class AppDrawer extends StatelessWidget {
  Widget _buildListTile({
    IconData iconData,
    String title,
    Function tapHandler,
  }) {
    return Column(
      children: [
        ListTile(
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
        ),
        Divider(
          thickness: 3,
        ),
      ],
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
          _buildListTile(
            iconData: Icons.shopping_basket,
            title: 'Shop',
            tapHandler: () => Navigator.of(context).pushReplacementNamed(
              ProductsOverviewScreen.routeName,
            ),
          ),
          _buildListTile(
            iconData: Icons.payment,
            // iconData: Icons.list_rounded,
            title: 'Orders',
            tapHandler: () => Navigator.of(context).pushReplacementNamed(
              OrdersScreen.routeName,
            ),
          ),
          _buildListTile(
            iconData: Icons.palette,
            // iconData: Icons.list_rounded,
            title: 'Manage Products',
            tapHandler: () => Navigator.of(context).pushReplacementNamed(
              UserProductsScreen.routeName,
            ),
          ),
          _buildListTile(
            iconData: Icons.exit_to_app,
            // iconData: Icons.logout,
            title: 'Logout',
            tapHandler: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushReplacementNamed('/'); // '/' - go to the home page

              Provider.of<Auth>(context, listen: false).logout();
              // context.read<Auth>().logout();
            },
          ),
        ],
      ),
    );
  }
}
