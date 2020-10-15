import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nitesh/Model/Appbar.dart';
import 'package:nitesh/Model/Pages.dart';
import 'package:nitesh/Service/AuthService.dart';
import 'package:nitesh/Shared/Drawer.dart';
import 'package:nitesh/Shared/Inputdecoration.dart';
import 'package:nitesh/Shared/Loading.dart';
import 'package:nitesh/commonAssets.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>  with SingleTickerProviderStateMixin{
  List<String> image = ['images/leaf.jpg','images/logo.png','images/sharingan.jpg'];
  int photoindex = 0;
  Animation animation;
  AnimationController controller;
  final GlobalKey _formkey = GlobalKey<FormState>();
  bool autovalidate = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(duration: Duration(seconds: 6),vsync: this);
    animation =  IntTween(begin: 0,end: image.length - 1).animate(controller)
      ..addListener(() {
        setState(() {
          //print(animation.value);
          photoindex = animation.value;
        });
      });

    // controller.repeat();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.repeat();
    final _pageprovider = Provider.of<PageProvider>(context);
    final width =  MediaQuery.of(context).size.width;
    final heghit = MediaQuery.of(context).size.height;
    return   WillPopScope(
      onWillPop: (){
        return _pageprovider.setpages('Home',_pageprovider.page.toString());
      },
      child: Scaffold(

        appBar: appbarWWidget(),
        body: Padding(
          padding: EdgeInsets.fromLTRB(width * 0.01, heghit * 0.01, width * 0.01, 0.0),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/leaf.jpg')
              )
            ),
            child: Image(
              image: AssetImage(image[photoindex]),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            //alertBox();
            controller.stop();
            _pageprovider.setpages('Order',_pageprovider.page);
          },
          backgroundColor: CommonAssets.buttonColor,
            child: Icon(Icons.highlight)
        ),
        drawer: PagesDrawer(controller: controller,page: _pageprovider.page,currentpage: 'Home',),
      ),
    );
  }

  Widget alertBox(){
     showDialog(

        context:context,
       barrierDismissible: false,
       builder: ( context){
          return AlertDialog(

            scrollable: true,
            title: Text('Add Detail'),
            content: Form(
              key: _formkey,
              autovalidate: autovalidate,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(

                  children: <Widget>[
                    Row(
                      children: <Widget>[

                        Flexible(
                          child: TextFormField(
                              decoration: showInput.copyWith(labelText: 'First Name',)
                          ),
                        ),
                        SizedBox(width: 10,),
                        Flexible(
                          child: TextFormField(
                              decoration: showInput.copyWith(labelText: 'Middle Name',)
                          ),
                        )

                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[

                        Flexible(
                          child: TextFormField(
                              decoration: showInput.copyWith(labelText: 'Last Name',)
                          ),
                        ),
                        SizedBox(width: 10,),
                        Flexible(
                          child: TextFormField(
                              decoration: showInput.copyWith(labelText: 'State',)
                          ),
                        )

                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[

                        Flexible(
                          child: TextFormField(
                              decoration: showInput.copyWith(labelText: 'City',)
                          ),
                        ),
                        SizedBox(width: 10,),
                        Flexible(
                          child: TextFormField(
                              decoration: showInput.copyWith(labelText: 'Pincode',)
                          ),
                        )

                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[

                        Flexible(
                          child: TextFormField(
                              decoration: showInput.copyWith(labelText: 'Address',)
                          ),
                        ),
                        SizedBox(width: 10,),


                      ],
                    ),
                  ],
                ),
              )
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              )
            ],
          );
       }
     );
  }

}