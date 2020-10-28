import 'package:cloud_firestore/cloud_firestore.dart';

class OrderAddCancel{
  String UserNumber;
  int  OrderNumber;
  OrderAddCancel({this.UserNumber,this.OrderNumber});
  final CollectionReference _orderReference = Firestore.instance.collection('Order');
  final CollectionReference _OrderStatus = Firestore.instance.collection('OrderStatus');

  Future addOrder(
      String userId,
      int amount,
      String item,
      String category,
      int color,
      int quantity,
      String first,String middle,String last,String city,String address,

      int pincode,  String alternativenumber,String orderId,String paymenttype,
      String paymentId, )async{

      String OrderId = UserNumber+'-'+ OrderNumber.toString();
    await _orderReference.document(OrderId.toString()).setData({
      'UserId':userId,
      'ItemName':item,
      'Category':category,
      'Quantity':quantity,
      'GivenAmount':amount,
      'Color':color.toString(),
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
      'ConfirmOrderDate':'',
    'DeliveryDate':'null',
      'EnableItem':true


    });
  }
  Future orderStatus()async{
    String OrderId = UserNumber+'-'+ OrderNumber.toString();
    // _OrderStatus.document('Delivery').setData({});
    // _OrderStatus.document('Denied').setData({});
   final exist = await _OrderStatus.document('Request').get();
   if(exist.exists)
     {
      await _OrderStatus.document('Request')  .updateData({
        'Requested_Id':FieldValue.arrayUnion([OrderId]),
      });
     }
   else{
     await _OrderStatus.document('Request')  .setData({
       'Requested_Id':FieldValue.arrayUnion([OrderId]),
     });
   }

  }
}