import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  print('## SplashScreen.build()');
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Center(
        child: Text('Loading ... Please wait'),
      ),
    );
  }
}
