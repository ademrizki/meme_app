import 'package:flutter/material.dart';
import 'package:meme_app/src/providers/auth/splash_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  static const String id = 'SplashScreen';

  @override
  Widget build(BuildContext context) {
    Provider.of<SplashProvider>(context, listen: false).fnIsSignedIn(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.image),
            Text('Meme App'),
          ],
        ),
      ),
    );
  }
}
