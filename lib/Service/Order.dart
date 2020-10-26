import 'package:cloud_firestore/cloud_firestore.dart';

class OrderAddCancel{
  String UserNumber;
  int  OrderNumber;
  OrderAddCancel({this.UserNumber,this.OrderNumber});
  final CollectionReference _orderReference = Firestore.instance.collection('Order');

  Future addOrder(
      int amount,
      String item,
      String category,
      String color,
      int quantity,
      String first,String middle,String last,String city,String address,

      int pincode,  String alternativenumber,String orderId,String paymenttype,
      String paymentId, )async{

      String OrderId = UserNumber+'-'+ OrderNumber.toString();
    await _orderReference.document(OrderId.toString()).setData({
      'ItemType':item,
      'Category':category,
      'Quantity':quantity,
      'GivenAmount':amount,
      'Color':color,
      'First': first,
      'Middle':middle,
      'Last': last,
      'City': city,
      'Pincode': pincode,
      'Address': address,
      'AlternativeNumber':'',
      'OrderId':orderId,
      'Paymenttype':paymenttype,
      'PaymentId':paymentId,
      'Status':"Request",
      'AllowOrDenied':'',
      'ReasonForDenied':'',
      'OrderDate':FieldValue.serverTimestamp(),
      'ConfirmOrderDate':''


    });
  }

}