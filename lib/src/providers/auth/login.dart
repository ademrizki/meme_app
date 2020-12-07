import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meme_app/src/screens/auth/login.dart';
import 'package:meme_app/src/screens/dashboard/home.dart';
import 'package:meme_app/src/screens/profile/update_role.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final String clientID = "2814118488914579";
  final String fbUrl = "https://www.facebook.com/connect/login_success.html";

  Future signInWithFacebook(BuildContext context) async {
    final progressDialog = ProgressDialog(context);

    await progressDialog.show();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginFacebookWebViewScreen(
          url:
              'https://www.facebook.com/dialog/oauth?client_id=$clientID&redirect_uri=$fbUrl&response_type=token&scope=email,public_profile,',
        ),
        maintainState: true,
      ),
    );

    if (result != null) {
      final firebaseAuth = FirebaseAuth.instance;
      try {
        final facebookAuthCred = FacebookAuthProvider.credential(result);
        final UserCredential user = await firebaseAuth.signInWithCredential(facebookAuthCred);

        await _fnAddUser(context, userData: user.user);
        await progressDialog.hide();
      } catch (e) {
        await progressDialog.hide();
        print(e.toString());
      }
    }
  }

  Future signInWithGoogle(BuildContext context) async {
    final progressDialog = ProgressDialog(context);

    await progressDialog.show();

    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final GoogleAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential user = await FirebaseAuth.instance.signInWithCredential(credential);

        await _fnAddUser(context, userData: user.user);
      }
    } catch (e) {
      await progressDialog.hide();
      print('Google Sign In Error ==> ' + e.toString());
    }
  }

  Future _fnAddUser(
    BuildContext context, {
    @required User userData,
  }) async {
    final CollectionReference users = FirebaseFirestore.instance.collection('users');
    final SharedPreferences _preferences = await SharedPreferences.getInstance();

    try {
      final isUserExist = await users
          .where(
            'uid',
            isEqualTo: userData.uid,
          )
          .get();

      if (isUserExist.docs.isNotEmpty) {
        _preferences.setString('uid', userData.uid);
        await users.doc(userData.uid).update({
          'full_name': userData.displayName,
          'image_url': userData.photoURL,
          'last_login': DateTime.now().toString(),
        });
        return Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
      } else {
        _preferences.setString('uid', userData.uid);
        await users.doc(userData.uid).set({
          'uid': userData.uid,
          'full_name': userData.displayName,
          'image_url': userData.photoURL,
          'role': 1,
          'created_at': DateTime.now().toString(),
          'last_login': DateTime.now().toString(),
        });
        return Navigator.pushNamed(context, UpdateRoleScreen.id);
      }
    } catch (e) {
      print('User Check Error ==> ' + e.toString());
    }
  }
}
