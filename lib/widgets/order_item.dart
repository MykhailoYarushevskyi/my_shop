import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart';

class OrderItem extends StatefulWidget {
  final OrderItemData order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    // ------- my content ---------
    return AnimatedContainer(
      height: _expanded
          ? min(widget.order.products.length * 20.0 + 110, 200)
          : 100.0,
      duration: Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      child: Card(
        margin: EdgeInsets.all(10),
        //an adding the SingleChildScrollView widget above the Column widget
        //or using the ListView widget instead of the Column widget allows
        //avoid the error:
        //A RenderFlex overflowed by 1.2 pixels on the bottom.
        child: ListView(
          // child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
              subtitle: Text(
                  '${DateFormat('dd.MM.yyyy hh:mm a').format(widget.order.dateTime)}'),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 400),
              height: _expanded
                  ? min(widget.order.products.length * 20.0 + 10, 100)
                  : 0,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: ListView.builder(
                itemCount: widget.order.products.length,
                itemBuilder: (context, index) {
                  var product = widget.order.products[index];
                  // return ListTile(
                  //   leading: Text(
                  //     '${product.title}',
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w700,
                  //     ),
                  //   ),
                  //   // title:
                  //   //     Text('${product.quantity} x'),
                  //   trailing: Chip(
                  //     backgroundColor: Colors.white,
                  //     label: Text('${product.quantity} x\$${product.price}'),
                  //   ),
                  // );
                  // //    or:
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '${product.title}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' ${product.quantity}x\$${product.price}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//     // course's content
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 300),
//       height:
//           _expanded ? min(widget.order.products.length * 20.0 + 110, 200) : 95,
//       child: Card(
//         margin: EdgeInsets.all(10),
//         child: Column(
//           children: <Widget>[
//             ListTile(
//               title: Text('\$${widget.order.amount}'),
//               subtitle: Text(
//                 DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
//               ),
//               trailing: IconButton(
//                 icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
//                 onPressed: () {
//                   setState(() {
//                     _expanded = !_expanded;
//                   });
//                 },
//               ),
//             ),
//             AnimatedContainer(
//               duration: Duration(milliseconds: 300),
//               padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
//               height: _expanded
//                   ? min(widget.order.products.length * 20.0 + 10, 100)
//                   : 0,
//               child: ListView(
//                 children: widget.order.products
//                     .map(
//                       (prod) => Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Text(
//                             prod.title,
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             '${prod.quantity}x \$${prod.price}',
//                             style: TextStyle(
//                               fontSize: 18,
//                               color: Colors.grey,
//                             ),
//                           )
//                         ],
//                       ),
//                     )
//                     .toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//      --------- it does not animated content ----------
//       return Card(
//         margin: EdgeInsets.all(10),
//         child: Column(
//           children: <Widget>[
//             ListTile(
//               title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
//               subtitle: Text(
//                   '${DateFormat('dd.MM.yyyy hh:mm a').format(widget.order.dateTime)}'),
//               trailing: IconButton(
//                 icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
//                 onPressed: () {
//                   setState(() {
//                     _expanded = !_expanded;
//                   });
//                 },
//               ),
//             ),
//             if (_expanded)
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 15,
//                   vertical: 4,
//                 ),
//                 height: min(widget.order.products.length * 25.0 + 10, 120),
//                 child: ListView.builder(
//                   itemCount: widget.order.products.length,
//                   itemBuilder: (context, index) {
//                     var product = widget.order.products[index];
//                     // return ListTile(
//                     //   leading: Text(
//                     //     '${product.title}',
//                     //     style: TextStyle(
//                     //       fontSize: 18,
//                     //       fontWeight: FontWeight.w700,
//                     //     ),
//                     //   ),
//                     //   // title:
//                     //   //     Text('${product.quantity} x'),
//                     //   trailing: Chip(
//                     //     backgroundColor: Colors.white,
//                     //     label: Text('${product.quantity} x\$${product.price}'),
//                     //   ),
//                     // );
//                     return Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Text(
//                           '${product.title}',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           ' ${product.quantity}x\$${product.price}',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
