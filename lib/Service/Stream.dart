import 'package:cloud_firestore/cloud_firestore.dart';

class AllStream{
  String number ;
  AllStream({this.number});

  Stream<DocumentSnapshot> get PERSONALINFO{
    return Firestore.instance.collection('Users').document(number).snapshots();
  }
}