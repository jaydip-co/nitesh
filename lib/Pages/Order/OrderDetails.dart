import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nitesh/Model/Appbar.dart';
import 'package:nitesh/Model/Pages.dart';
import 'package:nitesh/Model/Product.dart';
import 'package:nitesh/Model/User.dart';
import 'package:nitesh/Pages/Order/UserOrder.dart';
import 'package:nitesh/Service/Order.dart';
import 'package:nitesh/Service/Stream.dart';
import 'package:nitesh/Shared/Loading.dart';
import 'package:nitesh/commonAssets.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class OrderDetails extends StatefulWidget {
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  String usernumber;
  int amount;// given amount
  int ordernumber;
  String c_first;
  String c_middle;
  String c_last;
  String c_address;
  String c_cities;
  int c_pincode;
  String c_item;
  String c_category;
  String c_color;
  Razorpay _razorpay;

  bool sucessfullpayment= false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlerSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlerERROR);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handlerExternal);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }
  void Oncheck() async {
    var option = {
      'key': 'rzp_test_oVISAWTbmFIa5E',
      'amount': amount * 100,
      'name': 'TheERRORAD',
      'description': 'Test',
      'prefill': {'contact': 9512676561, 'email': ''},//widget.number.toString()
      'extranal': ['paytm']
    };
    try {
      _razorpay.open(option);
    } catch (e) {

      // print(e.toString());
    }
  }



  void _handlerSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(
      msg: 'Success :' + response.toString(),
    );
   await Firestore.instance
        .collection('Users')
        .document(usernumber)
        .updateData({
      'OrderNumber': ordernumber ,
      'LastOrder': FieldValue.arrayUnion([usernumber + '-' + '$ordernumber'])
    });
    await OrderAddCancel(UserNumber: usernumber, OrderNumber: ordernumber)
        .addOrder(
      amount,
      c_item,
      c_category,
      c_color,
      1,//set quantity
      c_first,
      c_middle,
      c_last,
      c_cities,
      c_address,
      c_pincode,
      '',
      usernumber + '-' + '$ordernumber',
      'Card',
      response.paymentId.toString(),
    );

    await setState(() {
      sucessfullpayment = true;
    });


  }

  void _handlerERROR(
      PaymentFailureResponse response,
      ) {
    Fluttertoast.showToast(
      msg: 'Fail :' + response.toString(),
    );
  }

  void _handlerExternal(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: 'External :' + response.toString(),
    );
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final _user = Provider.of<User>(context);
    final _tempproduct = Provider.of<TempProduct>(context);
    final _pageprovider = Provider.of<PageProvider>(context);


    if(!sucessfullpayment){
      return StreamBuilder<DocumentSnapshot>(
          stream: AllNumberStream(number: _user.UserNumber).PERSONALINFO,
          builder: (context,snapshot){
            return StreamBuilder<DocumentSnapshot>(
                stream: ProducStream(product: _tempproduct.productName).PRODUCTSTREAM,
                builder: (context,snapshot1){
                  if(snapshot.hasData && snapshot1.hasData){

                    return WillPopScope(
                      onWillPop: (){
                        return _pageprovider.setpages(_pageprovider.previouspage,_pageprovider.page.toString());
                      },
                      child: Scaffold(
                        appBar: appbarWWidget(),
                        body: Container(
                          width: width,
                          height:height,
                          color: CommonAssets.orderpagebackcolor,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding:  EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      side: new BorderSide(color: CommonAssets.buttonColor, width: 1.0),
//                                  borderRadius: BorderRadius.circular(4.0)
                                    ),
                                    color: Colors.white,
                                    child: ListTile(

                                        leading: Image(
                                          image: NetworkImage(snapshot1.data['Images'][0],

                                          ),

                                        ),
                                        title: Text(snapshot1.data['ItemTitle']),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,

                                          children: <Widget>[

                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  '₹'+  snapshot1.data['Price'].toString(),
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500
                                                  ),

                                                ),


                                              ],
                                            ),
                                            Text(
                                              'Qty             :  '+  _tempproduct.Quantity.toString(),
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  'Colors       :  ',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500
                                                  ),

                                                ),
                                                Container(
                                                  width: 20,
                                                  height :20,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8.0),
                                                    color: Colors.red,
                                                  ),
                                                ),

                                              ],
                                            ),
                                            Text(
                                              'Category   :  '+  _tempproduct.Category.toString(),
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500
                                              ),

                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                  SizedBox(height: 10,),

                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 8.0),
                                    width: width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
//                                borderRadius: BorderRadius.circular(4.0),
                                        border: Border(
                                          top: BorderSide(color: CommonAssets.buttonColor,width: 1),
                                          bottom: BorderSide(color: CommonAssets.buttonColor,width: 1),
                                          left: BorderSide(color: CommonAssets.buttonColor,width: 1),
                                          right: BorderSide(color: CommonAssets.buttonColor,width: 1),
                                        )
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(

                                          children: <Widget>[
                                            Text(
                                              snapshot.data['First'].toString()[0].toUpperCase()+snapshot.data['First'].toString().substring(1).toLowerCase(),
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),

                                            SizedBox(width: 2,),
                                            Text(
                                              snapshot.data['Middle'].toString()[0].toUpperCase()+snapshot.data['Middle'].toString().substring(1).toLowerCase(),
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(width: 2,),
                                            Text(
                                              snapshot.data['Last'].toString()[0].toUpperCase()+snapshot.data['Last'].toString().substring(1).toLowerCase(),
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 9,),
                                        Text(
                                          'Delivery Address',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Divider(color: Colors.black,thickness: 2.0,),
                                        SizedBox(height: 3,),
                                        Text(snapshot.data['Address'].toString(),
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w400,
                                          ),),
                                        SizedBox(height: 7,),
                                        Text(snapshot.data['Pincode'].toString(),
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w400,
                                          ),),
                                        SizedBox(height: 7,),
                                        Text(snapshot.data['City'].toString().toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w400,
                                          ),),
                                        SizedBox(height: 10,),
                                        Padding(

                                          padding:  EdgeInsets.symmetric(horizontal: 20.0),
                                          child: RaisedButton(
                                            padding: EdgeInsets.symmetric(vertical: 15.0),
                                            shape: StadiumBorder(),
                                            color: CommonAssets.buttonColor,
                                            onPressed: (){
                                              _pageprovider.setpages('Order',_pageprovider.page);
                                            },
                                            child: Center(child: Text(
                                              'Edit Address',
                                              style: TextStyle(
                                                  color: CommonAssets.buttonTextColor,
                                                  fontSize: 16.0
                                              ),
                                            )),
                                          ),

                                        ),
                                        SizedBox(height: 10.0,),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height :20),
                                  RaisedButton(
                                    elevation: 20.0,
                                    shape: StadiumBorder(),
                                    color: CommonAssets.buttonColor,
                                    padding: EdgeInsets.symmetric(horizontal: width * 0.3,vertical: 15.0),
                                    onPressed: ()async{
                                      setState(() {
                                        amount = snapshot1.data['Price'];
                                        usernumber =_user.UserNumber;
                                        ordernumber = snapshot.data['OrderNumber'] + 1;
                                        c_color = _tempproduct.ItemColor;
                                        c_category = _tempproduct.Category;
                                        c_item = _tempproduct.productName;

                                        c_address = snapshot.data['Address'];
                                        c_first= snapshot.data['First'];
                                        c_middle = snapshot.data['Middle'];
                                        c_last = snapshot.data['Last'];
                                        c_cities = snapshot.data['City'];
                                        c_pincode =snapshot.data['Pincode'];

                                      });
                                      await  Oncheck();
                                    },
                                    child: Text(
                                      'Buy',
                                      style: TextStyle(
                                          color: CommonAssets.buttonTextColor,
                                          fontSize: CommonAssets.buttontextsize

                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  else{
                    return Loading();
                  }
                }
            );
          }
      );
    }
    else{
      return UserOrder();
    }
  }
}
