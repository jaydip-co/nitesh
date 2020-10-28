import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nitesh/Model/Data/UserInfo.dart';

class AllNumberStream{
  String number ;
  AllNumberStream({this.number});

UserInf UserModelData(DocumentSnapshot snapshot){

  return UserInf(
    orderNumber: snapshot.data['OrderNumber'],
      number: snapshot.documentID,
    address: snapshot.data['Address'],
    first: snapshot.data['First'],
    middle: snapshot.data['Middle'],
    last : snapshot.data['Last'],
    city: snapshot.data['City'],
    pincode : snapshot.data['Pincode'],
  );
}

  // Stream<DocumentSnapshot> get PERSONALINFO{
  //   return Firestore.instance.collection('Users').document(number).snapshots();
  // }
 Stream<UserInf> get PERSONALINFO{
   return Firestore.instance.collection('Users').document(number).snapshots().map((UserModelData));
  }
}

class ProductStream{
  String product;
  ProductStream({this.product});
  Stream<DocumentSnapshot> get PRODUCTSTREAM{
    return Firestore.instance.collection('SellerProduct').document(product).snapshots();
  }

}

class OrderId{
  String Order_Id;
  OrderId({this.Order_Id});

  Stream<DocumentSnapshot> get ORDERIDSTREAM{
    return Firestore.instance.collection('Order').document(Order_Id).snapshots();
  }
}