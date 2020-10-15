import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nitesh/Model/User.dart';
import 'package:nitesh/Pages/Home.dart';
import 'package:nitesh/commonAssets.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User firebaseUser(FirebaseUser user) {
    return user != null
        ? User(uid: user.uid, UserNumber: user.phoneNumber)
        : null;
  }

  Stream<User> get USERSTREAM {
    return _auth.onAuthStateChanged.map((firebaseUser));
  }

  Future signout() async {
    return await _auth.signOut();
  }

  Future newUser(String number) async {
    try {
      final CollectionReference _usercollection =
      Firestore.instance.collection('Users');
      final existuser =
          await Firestore.instance.collection('Users').document(number).get();

      if (existuser.data == null) {
        await _usercollection.document(number).setData({
          'First': '',
          'Middle': '',
          'Last': '',
          'City': '',
          'Pindcode': int.parse('0'),
          'Address': '',
          'OrderNumber': int.parse('0'),
          'LastOrder':FieldValue.arrayUnion([])


        });
      }
      else{
        print('exist');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
