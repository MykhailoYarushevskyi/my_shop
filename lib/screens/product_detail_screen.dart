import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // ProductDetailScreen(this.title);
  static const String routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;

    // we do not need to rebuild this widget if addProduct() is called.
    // we only need data one time, but we are not interesting in updates.
    // Therefore the (listen: false),-then this widget here will not rebuild when
    // notifyListeners() is called. The Default value is "listen : true"
    final Product loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    //                     or
    // since the 4.1.0 version we can use instead of the Provider.of()
    // the context.watch<T>() or the context.select() inside the build() mehtod,
    // or the context.read<T>() (similar to [watch], but using outside
    //of the build()method (e.g.in actions or onPressed()) and doesn't make
    // widgets rebuild if the value obtained changes).
    // context.select((Products products) => products.findById(productId));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(loadedProduct.title),
      ),
      bottomNavigationBar: GestureDetector(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.only(
            left: 15,
            right: 15,
            bottom: 10,
            top: 5,
          ),
          color: Theme.of(context).backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Add to cart'),
              SizedBox(width: 10),
              Icon(Icons.shopping_cart),
            ],
          ),
        ),
        onTap: () {
          Cart cart = context.read<Cart>();
          cart.addItem(
            loadedProduct.id,
            loadedProduct.price,
            loadedProduct.title,
          );
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text('\$${loadedProduct.price}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                )),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedProduct.description,
                // maxLines: 10,
                style: Theme.of(context).textTheme.headline6,
                // overflow: TextOverflow.ellipsis,
                // overflow: TextOverflow.visible, //by default
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            // Spacer(),
          ],
        ),
      ),
    );
  }
}
