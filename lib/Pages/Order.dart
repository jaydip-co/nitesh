import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nitesh/Model/Appbar.dart';
import 'package:nitesh/Model/Pages.dart';
import 'package:nitesh/Model/User.dart';
import 'package:nitesh/Service/Database.dart';
import 'package:nitesh/Service/Order.dart';
import 'package:nitesh/Service/Stream.dart';
import 'package:nitesh/Shared/Drawer.dart';
import 'package:nitesh/Shared/Inputdecoration.dart';
import 'package:nitesh/Shared/Loading.dart';
import 'package:nitesh/commonAssets.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Order extends StatefulWidget {
  String number ;
  Order({this.number});
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  final  _formkey = GlobalKey<FormState>();
  String payment;
  String first;
  String middle;
  String last;

  String cities;
  int pincode;
  int oldorder;

  String c_first;
  String c_middle;
  String c_last;
  String c_address;
  String c_cities;
  int c_pincode;


  bool loop = false;
  var random ;
  String address;
  bool _autovalidate = false;
  List<String> citylist = List();
  int ordernumber ;
  Razorpay _razorpay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   _razorpay = Razorpay();
   _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlerSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlerERROR);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handlerExternal);
    _city();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

void Oncheck()async{
    var option = {
      'key':'rzp_test_oVISAWTbmFIa5E',
      'amount':500*100,
      'name':'TheERRORAD',
      'description':'Test',
      'prefill': {'contact': widget.number.toString(), 'email': ''},
      'extranal':['paytm']
    };
    try{
      _razorpay.open(option);


    }
    catch(e){
      print('userback');
      print(e.toString());
    }
}
void _handlerSuccess(PaymentSuccessResponse response)async{
    Fluttertoast.showToast(msg: 'Success :'+response.toString(),);
    await Firestore.instance.collection('Users').document(widget.number).updateData({
      'OrderNumber': ordernumber,
      'LastOrder':FieldValue.arrayUnion([widget.number+'-'+'$ordernumber'])
    });
    await  OrderAddCancel(UserNumber:  widget.number,OrderNumber:ordernumber).addOrder(


        c_first,
        c_middle,
        c_last,
        c_cities ,
        c_address,
        c_pincode ,
        '',
      widget.number+'-'+'$ordernumber',
        'Gateway',
        response.paymentId.toString(),

    );

  }
  void _handlerERROR(PaymentFailureResponse response,){
    Fluttertoast.showToast(msg: 'Fail :'+response.toString(),);

  }
  void _handlerExternal(ExternalWalletResponse response){
    Fluttertoast.showToast(msg: 'External :'+response.toString(),);
  }

  Future _city()async{
    print('hello');
    final   _city = await Firestore.instance.collection('states').document('Gujarat').get();
     // print(_city.data['City'].length);
      for(var i = 0 ;i< _city.data['City'].length - 1; i++)
        {
          setState(() {
                citylist.add(_city.data['City'][i]);
          });
        }
  }

  @override
  Widget build(BuildContext context) {
    final _pageprovider = Provider.of<PageProvider>(context);
    final user = Provider.of<User>(context);
    final width =  MediaQuery.of(context).size.width;
    final heghit = MediaQuery.of(context).size.height;
      return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection('Users').document(user.UserNumber).snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return WillPopScope(
              onWillPop: (){
                return _pageprovider.setpages('Home',_pageprovider.page.toString());
              },
              child: Scaffold(
                appBar: appbarWWidget(),
                body: Padding(
                  padding: EdgeInsets.fromLTRB(width * 0.05, heghit * 0.01, width * 0.05, 0.0),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0.0, heghit * 0.01,0.0, 0.0),
                      child: Form(
                        key: _formkey,
                        autovalidate: _autovalidate,
                        child: Column(

                          children: <Widget>[
                            TextFormField(
                              initialValue: snapshot.data['First'],
                              decoration: showInput.copyWith(labelText: 'First Name',),
                              validator: (val) => val.isEmpty ? 'Enter The First Name':null,
                              onChanged: (val) => first =val,

                            ),
                            SizedBox(height: 10,),
                            TextFormField(
                              initialValue: snapshot.data['Middle'],
                              decoration: showInput.copyWith(labelText: 'Middle Name',),
                              validator: (val) => val.isEmpty ? 'Enter The Middle Name':null,
                              onChanged: (val) => middle =val,
                            ),
                            SizedBox(height: 10,),
                            TextFormField(
                              initialValue: snapshot.data['Last'],
                              decoration: showInput.copyWith(labelText: 'Last Name',),
                              validator: (val) => val.isEmpty ? 'Enter The Last Name':null,
                              onChanged: (val) => last =val,
                            ),
                            SizedBox(height: 10,),
                            /* TextFormField(
                        decoration: showInput.copyWith(labelText: 'State',),
                      validator: (val) => val.isEmpty ? 'Enter The State Name ':null,
                    ),
                            SizedBox(height: 10,),*/
                            DropdownButtonFormField(

                              decoration: showInput.copyWith(labelText: 'City',),

                              onChanged: (val) => cities = val,
                              value:  snapshot.data['City'] ,

                              validator: (val) => val.isEmpty ? 'Enter The City Name ':null,
                              items: citylist.map((e){
                                return DropdownMenuItem(

                                  value: e.toString() ,
                                  child: Text(e),
                                );
                              }).toList(),
                            ),
                            /*TextFormField(
                        decoration: showInput.copyWith(labelText: 'City',),
                        validator: (val) => val.isEmpty ? 'Enter The City Name ':null,
                    ),*/
                            SizedBox(height: 10,),
                            TextFormField(
                              initialValue: snapshot.data['Pincode'].toString(),
                              keyboardType: TextInputType.phone,
                              decoration: showInput.copyWith(labelText: 'Pincode',),
                              onChanged: (val) => pincode =int.parse(val),
                              validator: validatepincode,
                            ),
                            SizedBox(height: 10,),
                            TextFormField(
                              initialValue: snapshot.data['Address'],
                              onChanged: (val) =>address = val.toString() ,
                              decoration: showInput.copyWith(labelText: 'Address',),
                              validator: (val) => val.isEmpty ? 'Enter The Address ':null,
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: RadioListTile(

                                    title: Text('Cash On Delivery'),
                                    value: 'COD',
                                    groupValue: payment,

                                    onChanged: (val) {
                                      setState(() {
                                        payment =val;
                                        print(payment);
                                      });
                                    },
                                  ),
                                ),
                                Flexible(
                                  child: RadioListTile(
                                    title: Text("Via Card"),
                                    value: 'Card',
                                    groupValue: payment,
                                    onChanged: (val) {
                                      setState(() {
                                        payment =val;
                                        print(payment);
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                            RaisedButton(
                              shape: StadiumBorder(),
                              padding: EdgeInsets.fromLTRB(40.0,20.0,40.0,20.0),
                              color: Colors.green.withOpacity(0.8),
                              child: Text(
                                'Confirm',
                                style: TextStyle(
                                    color: CommonAssets.buttonTextColor
                                ),
                              ),
                              onPressed: ()async{
                                if(_formkey.currentState.validate()){
                                   //order id
                                  DatabaseService(number: user.UserNumber).UpdateData(
                                    first ?? snapshot.data['First'].toString(),
                                    middle?? snapshot.data['Middle'].toString(),
                                    last?? snapshot.data['Last'].toString(),
                                    cities ?? snapshot.data['City'].toString(),
                                    address ?? snapshot.data['Address'].toString(),
                                    pincode ?? snapshot.data['Pincode'],
                                  );
                                 if(payment == "COD"){
                                 await  DatabaseService(number: user.UserNumber).codPaytem(snapshot.data['OrderNumber'] + 1);

                                  int ordernumber =  snapshot.data['OrderNumber'] + 1;
                                  String id = user.UserNumber+'-'+ordernumber.toString();
                                  await  OrderAddCancel(UserNumber:  user.UserNumber,OrderNumber:snapshot.data['OrderNumber'] + 1).addOrder(
                                       first ?? snapshot.data['First']..toString(),
                                       middle?? snapshot.data['Middle'].toString(),
                                       last?? snapshot.data['Last'].toString(),
                                       cities ?? snapshot.data['City'].toString(),
                                       address ?? snapshot.data['Address'].toString(),
                                       pincode ?? snapshot.data['Pincode'],
                                       '',
                                        '$id',
                                       'COD',
                                       'COD',

                                   );
                                 }
                                 else  if(payment == 'Card'){
                                   setState(() {
                                     ordernumber =snapshot.data['OrderNumber'] + 1;

                                     c_first=  first ?? snapshot.data['First'].toString();
                                     c_middle =middle?? snapshot.data['Middle'].toString();
                                     c_last= last?? snapshot.data['Last'].toString();
                                     c_cities= cities ?? snapshot.data['City'].toString();
                                     c_address= address ?? snapshot.data['Address'].toString();
                                     c_pincode= pincode ?? snapshot.data['Pincode'];
                                   });
                                   await Oncheck();


                                 }
                                }
                                else{
                                  setState(() {
                                    _autovalidate = true;
                                  });
                                }
                              },
                            )


                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                drawer: PagesDrawer(),
              ),
            );
          }
          else{
            return Loading();
          }
        }
      );
  }
  String validatepincode(String value){
    Pattern  pattern = r'^[0-9]{6}$';
    RegExp regExp = new RegExp(pattern);
    if(!regExp.hasMatch(value)){
      return 'Enter Valid PinCode';
    }
    else{
      return null;
    }
  }
}

