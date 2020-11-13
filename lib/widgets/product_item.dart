import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          // child: Icon(Icons.photo_library),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (context, product, child) => IconButton(
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () => {product.toggleFavoriteStatus()},
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
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
