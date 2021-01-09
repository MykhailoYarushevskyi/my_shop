import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/product.dart';

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
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                //for the tag, it is the same value that was given for
                //Hero's tag argument in ProductItem
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                Text('\$${loadedProduct.price}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),textAlign: TextAlign.center,),
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
                SizedBox(
                  height: 800,
                ),
              ],
            ),
            //In this case, this widget is for test scrolling of the screen
          ),
        ],
      ),
    );
  }
}
