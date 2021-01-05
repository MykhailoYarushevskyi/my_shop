import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders-screen';

//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
//   var _isLoading = false;
//   var _isInit = true;
//   @override
//   void initState() {
  // as a variant for call fetchAndSetOrders():
  // code below is incomplete, because it does not have error handling!
  // complete code see in didChangeDependencies()
  //Future.delayed(Duration.zero) will be performed after the initialization
//     Future.delayed(Duration.zero).then((_) async {
// //instead than in didChangeDependencies(),  it is possible
// //call fetchAndSetOrders() at this place.
// // if to use Provider.of<Orders>(context, listen: false) (or, may be,
// //context.read<Orders>()), it is possible call fetchAndSetOrders() without
// // of the Future.delayed(Duration.zero).
//       setState(() {
//         _isLoading = true;
//       });
//       await context.read<Orders>().fetchAndSetOrders();
//       setState(() {
//         _isLoading = false;
//       });
//     });
  //   super.initState();
  // }

  // @override
  // void didChangeDependencies() {
  // if (_isInit) {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   context.read<Orders>().fetchAndSetOrders().then((_) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }).catchError((error) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     showDialog(
  //       context: context,
  //       child: AlertDialog(
  //         actions: [
  //           FlatButton(
  //               child: Text('Ok'),
  //               onPressed: () {
  //                 // setState(() {
  //                 //   _isLoading = false;
  //                 // });
  //                 Navigator.of(context).pop();
  //               }),
  //         ],
  //         title: Text(
  //           'An Error occured!',
  //           style: TextStyle(
  //             color: Theme.of(context).errorColor,
  //             fontSize: 20,
  //           ),
  //         ),
  //         content: Text(
  //             'Something go wrong.\nMay be unavailable an internet connection'),
  //       ),
  //     );
  //   }).whenComplete(() => setState(() {
  //         _isLoading = false;
  //       }));
  // }
  // _isInit = false;
  //   super.didChangeDependencies();
  // }
  Widget showErrorMessage(BuildContext context, String hintMessage) {
    return Center(
      child: Container(
        height: 250,
        width: 250,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          border: Border.all(
            color: Theme.of(context).errorColor,
            width: 2.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'An Error occured!',
              style: TextStyle(
                color: Theme.of(context).errorColor,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Something go wrong.',
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text('In more detail:'),
                FlatButton(
                  child: Icon(Icons.help),
                  onPressed: () {
                    return Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Container(
                          height: 150,
                          margin: EdgeInsets.only(
                            top: 5,
                            left: 10,
                            right: 10,
                          ),
                          padding: EdgeInsets.all(10),
                          // color: Theme.of(context).backgroundColor,
                          child: Center(
                            // child: FittedBox(
                            child: Text(
                              hintMessage,
                              style: TextStyle(
                                  // color: Theme.of(context).errorColor,
                                  fontSize: 20),
                            ),
                            // ),
                          ),
                        ),
                        // action: SnackBarAction(label: 'Ok', onPressed: () {}),
                        duration: Duration(seconds: 4),
                      ),
                    );
                  },
                ),
                // FlatButton(
                //     child: Text('Ok'),
                //     onPressed: () {
                //       // setState(() {
                //       //   _isLoading = false;
                //       // });
                //       Navigator.of(context).pop();
                //     }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final ordersData = context.watch<Orders>();
    // the statement above cause an infinitive loop with the FutureBuilder
    // therefore moved it into the FutureBuilder in a Consumer<Orders>
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (context, dataSnapshot) {
            print('## OrdersScreen FutureBuilder.builder');
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (dataSnapshot.error != null) {
              return showErrorMessage(
                context,
                dataSnapshot.error.toString(),
              );
            } else {
              return Consumer<Orders>(builder: (context, ordersData, child) {
                return ListView.builder(
                    itemCount: ordersData.orders.length,
                    itemBuilder: (context, index) =>
                        OrderItem(ordersData.orders[index]));
              });
            }
          }),
      drawer: AppDrawer(),
    );
  }
}
