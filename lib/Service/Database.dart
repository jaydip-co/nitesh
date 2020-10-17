import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  String number ;
  DatabaseService({this.number});

  final CollectionReference _usercollection =  Firestore.instance.collection('Users');

  Future newUser() async {
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
          'City': 'Ahmadabad',
          'Pincode': int.parse('0'),
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


  Future UpdateData(String first,String middle,String last,String city,String address,int pincode,)async{

    await _usercollection.document(number).updateData({
      'First': first,
      'Middle':middle,
      'Last': last,
      'City': city,
      'Pincode': pincode,
      'Address': address,
    /*  'OrderNumber': order,
      'LastOrder':FieldValue.arrayUnion(['$number/'+'$order'])*/
    });

  }
  Future codPaytem(int order)async{

    await _usercollection.document(number).updateData({
      'OrderNumber': order,
      'LastOrder':FieldValue.arrayUnion([number+'-'+'$order'])
    });
  }
}