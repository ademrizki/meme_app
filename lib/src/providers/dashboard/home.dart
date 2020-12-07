import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');
  final CollectionReference contents = FirebaseFirestore.instance.collection('contents');
  var role;

  Future<DocumentSnapshot> fnFetchUserInfo() async {
    final SharedPreferences _preferences = await SharedPreferences.getInstance();
    final _userID = _preferences.getString('uid');

    final userData = await users.doc(_userID).get();
    final _userRole = userData.data()['role'];
    role = _userRole;
    return await users.doc(_userID).get();
  }

  Future<QuerySnapshot> fnFetchContents() async {
    return await contents.get();
  }

  fnSetItemCount(int itemLength) {
    print(role);
    print(itemLength);
    if (role == 1) {
      if (itemLength > 6) {
        return 6;
      }
    } else if (role == 2) {
      if (itemLength > 1) {
        return 1;
      }
    } else if (role == 3) {
      if (itemLength > 3) {
        return 3;
      }
    }
    return itemLength;
  }
}
