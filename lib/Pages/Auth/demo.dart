import 'package:flutter/material.dart';
import 'package:nitesh/Model/Pages.dart';
import 'package:nitesh/Shared/Drawer.dart';
import 'package:provider/provider.dart';
class Demo extends StatefulWidget {

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    final _pageprovider = Provider.of<PageProvider>(context);
    return WillPopScope(
      onWillPop: (){
        return _pageprovider.setpages('Home',_pageprovider.page.toString());
      },
      child: Scaffold(
      drawer: PagesDrawer(page: _pageprovider.page,),
      ),
    );

  }
}
