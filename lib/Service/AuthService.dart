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

  Future  MobileNumberColl(String number)async{
    try{
      final CollectionReference _mobile =  Firestore.instance.collection('MobileNumber');
      final exist = await _mobile.document('Allnumber').get();
      if(exist.exists)
      {
        await _mobile.document('Allnumber').updateData({
          'Number':FieldValue.arrayUnion([number])
        });
      }
      else{
        await _mobile.document('Allnumber').setData({
          'Number':FieldValue.arrayUnion([number])
        });
      }
    }
    catch(e){
      
    }
  }
//'Number':FieldValue.arrayUnion([number])
  Future signout() async {
    return await _auth.signOut();
  }



}
