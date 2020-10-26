import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nitesh/Model/Data/UserInfo.dart';

class AllNumberStream{
  String number ;
  AllNumberStream({this.number});

UserInfo UserModelData(DocumentSnapshot snapshot){
  return UserInfo(
      number: snapshot.documentID,
    address: snapshot.data['Address'],
    first: snapshot.data['First'],
    middle: snapshot.data['Middle'],
    last : snapshot.data['Last'],
    city: snapshot.data['City'],
    pincode : snapshot.data['Pincode'],
  );
}

  Stream<DocumentSnapshot> get PERSONALINFO{
    return Firestore.instance.collection('Users').document(number).snapshots();
  }
//  Stream<UserInfo> get PERSONALINFO{
//    return Firestore.instance.collection('Users').document(number).snapshots().map((UserModelData));
//  }
}

class ProducStream{
  String product;
  ProducStream({this.product});
  Stream<DocumentSnapshot> get PRODUCTSTREAM{
    return Firestore.instance.collection('SellerProduct').document(product).snapshots();
  }

}