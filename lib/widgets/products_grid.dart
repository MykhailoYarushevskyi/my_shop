import 'package:flutter/material.dart.';
import 'package:my_shop/providers/product.dart';
import 'package:provider/provider.dart';
import './product_item.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // since 4.1.0 version we can use instead of the Provider.of()
    // the context.watch<T>() or the context.select() (similar
    // to [watch], but doesn't make widgets rebuild if the value obtained changes).

    // final productsData = Provider.of<Products>(context);
    final productsData = context.watch<Products>();
    final products = productsData.items;
    print('## ProductsGrid.build()');
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      // itemBuilder: (context, index) => ChangeNotifierProvider(
      //   create: (context) => products[index],

      //if our data (Products())does not depend on the context, 
      //also for avoiding bugs in case using in ListView or GridView 
      //(might its fix already), we can use ChangeNotifierProvider.value:
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(),
      ),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
      //   childAspectRatio: 3 / 2,
      //   crossAxisSpacing: 10,
      //   mainAxisSpacing: 10,
      //   maxCrossAxisExtent: 200,
      // ),
    );
  }
}
