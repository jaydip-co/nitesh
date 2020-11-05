import 'package:flutter/material.dart';
import 'package:nitesh/commonAssets.dart';

Widget appbarWWidget(){
  return  AppBar(
    backgroundColor: CommonAssets.appbarColor,
    iconTheme:new IconThemeData(color:CommonAssets.appbardrawerColor),

    title: Text(
      CommonAssets.appTitle,
      style: TextStyle(
          color: CommonAssets.appbarTextColor
      ),
    ),

  );
}
