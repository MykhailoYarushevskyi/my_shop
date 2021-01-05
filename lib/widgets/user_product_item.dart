import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem({
    this.id,
    this.title,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final scaffoldOf = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      // leading: Image.network(imageUrl),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
                arguments: id,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Are you sure?',
                      textAlign: TextAlign.center,
                    ),
                    content: Text(
                      'Do you want to remove this product?',
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      FlatButton(
                        child: Text('No'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () async {
                          print('## UserProductItem.delete() Entry');
                          try {
                            await context.read<Products>().deleteProduct(id);
                          } catch (error) {
                            print('## UserProductItem catch block. error: $error');
                            scaffoldOf.showSnackBar(
                              SnackBar(
                                content: Text('Deleting failed!', textAlign: TextAlign.center,),
                              ),
                            );
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
