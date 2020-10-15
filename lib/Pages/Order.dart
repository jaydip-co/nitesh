import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nitesh/Model/Appbar.dart';
import 'package:nitesh/Model/Pages.dart';
import 'package:nitesh/Shared/Drawer.dart';
import 'package:nitesh/Shared/Inputdecoration.dart';
import 'package:nitesh/commonAssets.dart';
import 'package:provider/provider.dart';

class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  final  _formkey = GlobalKey<FormState>();
  String payment;
  String first;
  String middle;
  String last;
  String state;
  String cities;
  int pincode;
  bool loop = false;
  var random ;
  String address;
  bool _autovalidate = false;
  List<String> citylist = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //_city();

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

    final width =  MediaQuery.of(context).size.width;
    final heghit = MediaQuery.of(context).size.height;
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

              child: Form(
                key: _formkey,
                autovalidate: _autovalidate,
                child: Column(

                  children: <Widget>[
                    TextFormField(
                        decoration: showInput.copyWith(labelText: 'First Name',),
                        validator: (val) => val.isEmpty ? 'Enter The First Name':null,
                      onChanged: (val) => first =val,
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                        decoration: showInput.copyWith(labelText: 'Middle Name',),
                      validator: (val) => val.isEmpty ? 'Enter The Middle Name':null,
                      onChanged: (val) => middle =val,
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                        decoration: showInput.copyWith(labelText: 'Last Name',),
                      validator: (val) => val.isEmpty ? 'Enter The Last Name':null,
                      onChanged: (val) => last =val,
                    ),
                    SizedBox(height: 10,),
                   /* TextFormField(
                        decoration: showInput.copyWith(labelText: 'State',),
                      validator: (val) => val.isEmpty ? 'Enter The State Name ':null,
                    ),*/
                    SizedBox(height: 10,),
                    DropdownButtonFormField(
                      decoration: showInput.copyWith(labelText: 'City',),
                      onChanged: (val) => cities = val,
                      validator: (val) => val.isEmpty ? 'Enter The City Name ':null,
                      items: citylist.map((e){
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
                    SizedBox(height: 10,),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                        decoration: showInput.copyWith(labelText: 'Pincode',),
                      onChanged: (val) => pincode =int.parse(val),
                      validator: validatepincode,
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                        decoration: showInput.copyWith(labelText: 'Address',),
                      validator: (val) => val.isEmpty ? 'Enter The Address ':null,
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: RadioListTile(
                            title: Text('COD'),
                            value: 'Cod',
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

                      color: Colors.green.withOpacity(0.8),
                      child: Text(
                          'Confirm',
                        style: TextStyle(
                          color: CommonAssets.buttonTextColor
                        ),
                      ),
                      onPressed: (){
                        if(_formkey.currentState.validate()){


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

