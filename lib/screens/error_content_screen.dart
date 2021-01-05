import 'package:flutter/material.dart';

class ErrorContentScreen extends StatelessWidget {
  static const String routeName = '/error-content-screen';

  @override
  Widget build(BuildContext context) {
    final String errorContent =
        ModalRoute.of(context).settings.arguments.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Content of an error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              elevation: 8.00,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  errorContent,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            RaisedButton(
              child: Text(
                'Ok',
                style: TextStyle(
                    color: Theme.of(context).errorColor, fontSize: 24),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
