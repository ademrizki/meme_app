import 'package:flutter/material.dart';
import 'package:meme_app/src/screens/auth/login.dart';
import 'package:meme_app/src/screens/dashboard/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashProvider extends ChangeNotifier {
  Future fnIsSignedIn(BuildContext context) async {
    final SharedPreferences _preferences = await SharedPreferences.getInstance();
    final _userID = _preferences.getString('uid');

    switch (_userID) {
      case null:
        return Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false);
        break;
      default:
        return Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
        break;
    }
  }
}
