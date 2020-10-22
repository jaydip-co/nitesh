import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nitesh/Model/Appbar.dart';
import 'package:nitesh/Model/Pages.dart';
import 'package:nitesh/Model/Product.dart';
import 'package:nitesh/Pages/Item/Product.dart';
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
    final _tempProduct = Provider.of<TempProduct>(context);

    final width =  MediaQuery.of(context).size.width;
    final heghit = MediaQuery.of(context).size.height;
    return   StreamBuilder<QuerySnapshot>(
      
      stream: Firestore.instance.collection('SellerProduct').snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasData)
          {
            return WillPopScope(
              onWillPop: (){
                return _pageprovider.setpages('Home',_pageprovider.page.toString());
              },
              child: Scaffold(

                appBar: appbarWWidget(),
                body:  Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(

                        width: width,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                            image:DecorationImage(
                                image: AssetImage(image[photoindex]),
                                fit: BoxFit.cover
                            )
                        ),

                      ),
                      Divider(
                         color: CommonAssets.dividerColor,
                        thickness: 2.0,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data.documents.length,
                            itemBuilder: (context,index){
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white
                              ),
                              child: GestureDetector(
                                onTap: ()async{
                                  controller.stop();
                                 await _tempProduct.setProduct(snapshot.data.documents[index].documentID);
                                 return _pageprovider.setpages('Product',_pageprovider.page);

                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 160.0,
                                        width: 180.0,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(color: Colors.black),
                                            bottom: BorderSide(color: Colors.black),
                                            left: BorderSide(color: Colors.black),
                                            right: BorderSide(color: Colors.black),
                                          ),
                                            borderRadius: BorderRadius.circular(30.0),

                                            image: DecorationImage(
                                                image: NetworkImage(snapshot.data.documents[index]['Images'][0]),
                                                fit: BoxFit.cover
                                            )
                                        ),

                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(snapshot.data.documents[index].documentID.toString() + ''),
                                      ),
                                      Text('₹'+snapshot.data.documents[index]['Price'].toString()),
                                      Divider(color: CommonAssets.dividerColor, thickness: CommonAssets.dividerthickness,),
                                    ],
                                  ),
                                ),
                              ),
                            );
                            }
                        ),
                      )
                    ],
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
        else{
          return Loading();
        }
      }
    );
  }

}

Widget itemcard(QuerySnapshot snapshot,int index){
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Container(
          height: 160.0,
          width: 180.0,

          decoration: BoxDecoration(


              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                  image: AssetImage('images/leaf.jpg',),
                  fit: BoxFit.cover
              )
          ),

        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('ss'),
        ),
        Text('500'),

      ],
    ),
  );
}