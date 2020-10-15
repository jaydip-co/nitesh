import 'package:flutter/material.dart';
import 'package:nitesh/Model/Pages.dart';
import 'package:nitesh/Service/AuthService.dart';
import 'package:nitesh/commonAssets.dart';
import 'package:provider/provider.dart';
class PagesDrawer extends StatefulWidget {
  AnimationController controller;
  String page;
  String currentpage ;
    PagesDrawer({this.controller,this.page,this.currentpage});
  @override
  _PagesDrawerState createState() => _PagesDrawerState();
}

class _PagesDrawerState extends State<PagesDrawer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

        if(widget.page == "Home" && widget.currentpage != 'Home' )
        {
          widget.controller.stop();
        }

  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final _pageprovider = Provider.of<PageProvider>(context);
    return Drawer(

        child: ListView(
         children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black)
              ),
              image: DecorationImage(
                image: AssetImage('images/logo.png')
              )
            ),
            child: Text(''),

          ),
           ListTile(
             onTap: (){
               //widget.controller.repeat();
               _pageprovider.setpages('Home',_pageprovider.page.toString());
             },
             title: Row(
               children: <Widget>[
                 Icon(Icons.home),
                 SizedBox(width: 20,),
                 Text('Home')
               ],
             )
           ),
           ListTile(
               onTap: (){
                 if(widget.page == "Home")
                 {
                   widget.controller.stop();
                 }
                 _pageprovider.setpages('Profile',_pageprovider.page.toString());
               },
               title: Row(
                 children: <Widget>[
                   Icon(Icons.shopping_cart),
                   SizedBox(width: 20,),
                   Text('Previous Orders')
                 ],
               )
           ),
           ListTile(
               onTap: (){
                widget.controller.stop();
                _auth.signout();
               },
               title: Row(
                 children: <Widget>[
                   Icon(Icons.exit_to_app),
                   SizedBox(width: 20,),
                   Text('SignOut')
                 ],
               )
           ),

         ],
        )
    );
  }
}

