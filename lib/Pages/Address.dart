import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nitesh/Common/CircularProgressIndicotr.dart';
import 'package:nitesh/Model/Appbar.dart';
import 'package:nitesh/Model/Pages.dart';
import 'package:nitesh/Model/User.dart';

import 'package:nitesh/Pages/Home.dart';

import 'package:nitesh/Service/Database.dart';
import 'package:nitesh/Service/Order.dart';
import 'package:nitesh/Service/Stream.dart';
import 'package:nitesh/Shared/Drawer.dart';
import 'package:nitesh/Shared/Inputdecoration.dart';
import 'package:nitesh/Shared/Loading.dart';
import 'package:nitesh/Shared/PagesWapper.dart';
import 'package:nitesh/commonAssets.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Order extends StatefulWidget {
  String number;

  Order({this.number});

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  final _formkey = GlobalKey<FormState>();
  String payment;
  String first;
  String middle;
  String last;

  String cities;
  int pincode;
  int oldorder;



  bool loop = false;

  var random;

  String address;
  bool _autovalidate = false;
  List<String> citylist = List();
  int ordernumber;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _city();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }




  Future _city() async {
    
    final _city =
        await Firestore.instance.collection('states').document('Gujarat').get();
    // print(_city.data['City'].length);
    for (var i = 0; i < _city.data['City'].length - 1; i++) {
      setState(() {
        citylist.add(_city.data['City'][i]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _pageprovider = Provider.of<PageProvider>(context);
    final user = Provider.of<User>(context);
    final width = MediaQuery.of(context).size.width;
    final heghit = MediaQuery.of(context).size.height;


      return Scaffold(
        appBar: appbarWWidget(),
        body: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection('Users')
                .document(user.UserNumber)
                .snapshots(),
            builder: (context, snapshot) {


              if (snapshot.hasData) {
                return WillPopScope(
                  onWillPop: () {
                    return _pageprovider.setpages(
                        _pageprovider.previouspage, 'Product');
                  },
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          width * 0.05, heghit * 0.01, width * 0.05, 0.0),
                      child: SingleChildScrollView(
                        child: Container(
                          padding:
                          EdgeInsets.fromLTRB(0.0, heghit * 0.01, 0.0, 0.0),
                          child: Form(
                            key: _formkey,
                            autovalidate: _autovalidate,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  initialValue: snapshot.data['First'],
                                  decoration: showInput.copyWith(
                                    labelText: 'First Name',
                                  ),
                                  validator: (val) =>
                                  val.isEmpty ? 'Enter The First Name' : null,
                                  onChanged: (val) => first = val,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  initialValue: snapshot.data['Middle'],
                                  decoration: showInput.copyWith(
                                    labelText: 'Middle Name',
                                  ),
                                  validator: (val) =>
                                  val.isEmpty ? 'Enter The Middle Name' : null,
                                  onChanged: (val) => middle = val,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  initialValue: snapshot.data['Last'],
                                  decoration: showInput.copyWith(
                                    labelText: 'Last Name',
                                  ),
                                  validator: (val) =>
                                  val.isEmpty ? 'Enter The Last Name' : null,
                                  onChanged: (val) => last = val,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                /* TextFormField(
                        decoration: showInput.copyWith(labelText: 'State',),
                      validator: (val) => val.isEmpty ? 'Enter The State Name ':null,
                    ),
                            SizedBox(height: 10,),*/
                                DropdownButtonFormField(
                                  decoration: showInput.copyWith(
                                    labelText: 'City',
                                  ),
                                  onChanged: (val) => cities = val,
                                  value: snapshot.data['City'],
                                  validator: (val) =>
                                  val.isEmpty ? 'Enter The City Name ' : null,
                                  items: citylist.map((e) {
                                    return DropdownMenuItem(
                                      value: e.toString(),
                                      child: Text(e),
                                    );
                                  }).toList(),
                                ),
                                /*TextFormField(
                        decoration: showInput.copyWith(labelText: 'City',),
                        validator: (val) => val.isEmpty ? 'Enter The City Name ':null,
                    ),*/
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  initialValue: snapshot.data['Pincode'].toString(),
                                  keyboardType: TextInputType.phone,
                                  decoration: showInput.copyWith(
                                    labelText: 'Pincode',
                                  ),
                                  onChanged: (val) => pincode = int.parse(val),
                                  validator: validatepincode,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  initialValue: snapshot.data['Address'],
                                  onChanged: (val) => address = val.toString(),
                                  decoration: showInput.copyWith(
                                    labelText: 'Address',
                                  ),
                                  validator: (val) =>
                                  val.isEmpty ? 'Enter The Address ' : null,
                                ),
                                SizedBox(
                                  height: 10,
                                ),

                                RaisedButton(
                                  shape: StadiumBorder(),
                                  padding:
                                  EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 20.0),
                                  color: Colors.green.withOpacity(0.8),
                                  child: Text(
                                    'Confirm',
                                    style: TextStyle(
                                        color: CommonAssets.buttonTextColor),
                                  ),
                                  onPressed: () async {
                                    if (_formkey.currentState.validate()) {
                                      //order id
                                      DatabaseService(number: user.UserNumber)
                                          .UpdateData(
                                        first ?? snapshot.data['First'].toString(),
                                        middle ??
                                            snapshot.data['Middle'].toString(),
                                        last ?? snapshot.data['Last'].toString(),
                                        cities ?? snapshot.data['City'].toString(),
                                        address ??
                                            snapshot.data['Address'].toString(),
                                        pincode ?? snapshot.data['Pincode'],
                                      );
                                      _pageprovider.setpages('ConfirmDetails',_pageprovider.page);
                                    } else {
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
                    //   drawer: PagesDrawer(),

                );
              } else {
                return CircularLoading();
              }
            }),
      );

  }

  String validatepincode(String value) {
    Pattern pattern = r'^[0-9]{6}$';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Enter Valid PinCode';
    } else {
      return null;
    }
  }
}
