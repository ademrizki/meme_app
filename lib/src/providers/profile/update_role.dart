import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meme_app/src/screens/dashboard/home.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateRoleProvider extends ChangeNotifier {
  int role = 1;
  List<DropdownMenuItem> items = [
    DropdownMenuItem(
      child: Text('Level A'),
      value: 1,
    ),
    DropdownMenuItem(
      child: Text('Level B'),
      value: 2,
    ),
    DropdownMenuItem(
      child: Text('Level C'),
      value: 3,
    ),
  ];

  void fnOnChanged(int value) {
    role = value;
    notifyListeners();
  }

  Future fnOnSaved(BuildContext context) async {
    final SharedPreferences _preferences = await SharedPreferences.getInstance();
    final CollectionReference users = FirebaseFirestore.instance.collection('users');
    final progressDialog = ProgressDialog(context);

    await progressDialog.show();

    try {
      final _userID = _preferences.getString('uid');

      await users.doc(_userID).update({
        'role': this.role,
      });

      return Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
    } catch (e) {
      await progressDialog.hide();
      print('Update Role Error ==> ' + e.toString());
    }
  }
}
