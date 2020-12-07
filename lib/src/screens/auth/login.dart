import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:meme_app/src/providers/auth/login.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'LoginScreen';

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<LoginProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Icon(
                CupertinoIcons.news,
                size: 80,
              ),
            ),
            Row(
              children: [
                Icon(CupertinoIcons.forward),
                Text(
                  'Welcome to Meme App!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            SizedBox(height: 80),
            Column(
              children: [
                SignInButton(
                  Buttons.Facebook,
                  text: 'Sign In with Facebook',
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onPressed: () async => await _provider.signInWithFacebook(context),
                ),
                SizedBox(height: 5),
                Text('- OR - '),
                SizedBox(height: 5),
                SignInButton(
                  Buttons.Google,
                  text: 'Sign In with Google',
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onPressed: () async => await _provider.signInWithGoogle(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LoginFacebookWebViewScreen extends StatefulWidget {
  final String url;

  LoginFacebookWebViewScreen({this.url});

  @override
  _LoginFacebookWebViewScreenState createState() => _LoginFacebookWebViewScreenState();
}

class _LoginFacebookWebViewScreenState extends State<LoginFacebookWebViewScreen> {
  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (url.contains("#access_token")) {
        succeed(url);
      }

      if (url.contains(
          "https://www.facebook.com/connect/login_success.html?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied")) {
        Navigator.pop(context);
      }
    });
  }

  succeed(String url) {
    var params = url.split("access_token=");

    var endParams = params[1].split("&");

    Navigator.pop(context, endParams[0]);
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(66, 103, 178, 1),
        title: new Text("Facebook login"),
      ),
      url: widget.url,
    );
  }
}
