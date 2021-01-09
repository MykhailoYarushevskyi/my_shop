import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffoldOf = Scaffold.of(context);
    final authData = Provider.of<Auth>(context, listen: false);
    final product = Provider.of<Product>(context, listen: false);
    print('## ProductItem.build() rebuilds');
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          // onTap: () => Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (contextll) => ProductDetailScreen(),
          //   ),
          // ),
          onTap: () => Navigator.of(context)
              .pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              )
              .then(
                (value) => {
                  print('## ProductItem: Future.then() method. Value = $value'),
                },
              ),
          child: Hero(
            // in general, that can be any tag you want,
            // but it should be unique per image
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage(
                'assets/images/product-placeholder.png',
              ),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          // child: Image.network(
          //   product.imageUrl,
          //   fit: BoxFit.cover,
          // ),
          // child: Icon(Icons.photo_library),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (context, product, child) => IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () {
                  product
                      .toggleFavoriteStatus(authData.token, authData.userId)
                      .catchError((error) {
                    print(
                        '## ProductItem: toggleFavoriteStatus().catchError() = $error');
                    scaffoldOf.showSnackBar(SnackBar(
                      content: Text(
                        'Toggle "favorite" failed.',
                        textAlign: TextAlign.center,
                      ),
                    ));
                  });
                },
                color: Theme.of(context).accentColor),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Cart cart = context.read<Cart>();
              cart.addItem(
                product.id,
                product.price,
                product.title,
              );
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added product to the cart',
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      Cart cart = context.read<Cart>();
                      cart.reduceItemQuantity(product.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
