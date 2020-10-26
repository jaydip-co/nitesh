import 'package:flutter/material.dart';

import '../commonAssets.dart';
const inputdecoration = InputDecoration(
  contentPadding: EdgeInsets.all(25.0),

  labelText: 'Mobile Number',

  /* enabledBorder: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.green),

),
  focusedErrorBorder:OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green),

  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red),


  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red),

  ),*/


);
 InputDecoration showInput = InputDecoration(

   enabledBorder: OutlineInputBorder(
       borderSide: BorderSide(color: Colors.green),
       borderRadius: BorderRadius.circular(15.0)),
   focusedBorder: OutlineInputBorder(
       borderSide: BorderSide(color: Colors.green),
       borderRadius: BorderRadius.circular(15.0)),
     focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red),borderRadius: BorderRadius.circular(15.0)),
     errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red),borderRadius: BorderRadius.circular(15.0)),
   labelStyle: TextStyle(color: CommonAssets.labelTextColor),
 );

 InputDecoration dropdownDecoration = InputDecoration(
   enabledBorder: OutlineInputBorder(
       borderSide: BorderSide(color:CommonAssets.dropdownbordercolor),
       borderRadius: BorderRadius.circular(15.0)
   ),
   focusedBorder: OutlineInputBorder(
       borderSide: BorderSide(color:Colors.green),
       borderRadius: BorderRadius.circular(15.0)
   ),
 );