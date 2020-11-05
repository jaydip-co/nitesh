import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' as Io;

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nitesh/Common/CircularProgressIndicotr.dart';
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

  // List<String> image = ['images/leaf.jpg','images/logo.png','images/sharingan.jpg'];
  List<String> image =['images/leaf.jpg'];
      int photoindex = 0;
  int max = 1;
  Animation animation;
  AnimationController controller;
  final GlobalKey _formkey = GlobalKey<FormState>();
  bool autovalidate = false;
  num saveamount;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ImageCollector();

    controller = AnimationController(duration: Duration(seconds: 6),vsync: this);
    animaton();
    controller.stop();
    // controller.repeat();

  }
  animaton(){
    animation =  IntTween(begin: 0,end: max - 1).animate(controller)
      ..addListener(() {
        setState(() {
          //print(animation.value);
          photoindex = animation.value;

        });
      });
  }
  Future ImageCollector()async{
    try{
      final imagedata = await Firestore.instance.collection('Images').document('Images').get();
      setState(() {
        max = imagedata.data['Images'].length;

        animaton();
      });
    }
    catch(e){
      
    }
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
    return   Scaffold(
      appBar: appbarWWidget(),
      body: StreamBuilder<DocumentSnapshot>(
        stream:  Firestore.instance.collection('Images').document('Images').snapshots(),
            builder: (context,Imagesanpshot){
              if(Imagesanpshot.hasData)
                {
                  ImageCollector();
                return  StreamBuilder<QuerySnapshot>(

                      stream: Firestore.instance.collection('SellerProduct').where('EnableItem',isEqualTo: true).orderBy('ItemRank',descending: false).snapshots(),
                      builder: (context, snapshot) {

                        if(snapshot.hasData)
                        {


                        return WillPopScope(
                          onWillPop: (){
                            return _pageprovider.setpages('Home',_pageprovider.page.toString());
                          },
                          child:  Container(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(

                                  width: width,
                                  height: 250,
                                  decoration: BoxDecoration(
                                      color: Colors.white10,
                                      image:DecorationImage(
                                          image: NetworkImage(Imagesanpshot.data['Images'][photoindex]),
                                          fit: BoxFit.cover
                                      )
                                  ),

                                ),
                                // Divider(
                                //   color: CommonAssets.dividerColor,
                                //
                                // ),
                                SizedBox(height: 10,),
                                Expanded(
                                  child: ListView.builder(
                                      itemExtent: 150,
                                      itemCount: snapshot.data.documents.length,
                                      itemBuilder: (context,index){
                                        saveamount = snapshot.data.documents[index]['MRP'] - snapshot.data.documents[index]['Price'];
                                        return GestureDetector(
                                          onTap: ()async{
                                            controller.stop();
                                            await _tempProduct.setProduct(snapshot.data.documents[index].documentID);
                                            return _pageprovider.setpages('Product',_pageprovider.page);
                                          },
                                          child: Card(

                                            shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black,width: 0.4),borderRadius: BorderRadius.circular(4.0)),
                                            clipBehavior: Clip.antiAlias,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Card(
                                                  child: Container(
                                                      width:  180,
                                                      height: 150,


                                                      child: Image(
                                                        image: NetworkImage(snapshot.data.documents[index]['Images'][0]),
                                                      )
                                                  ),
                                                ),

                                                Expanded(
                                                  child:  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        snapshot.data.documents[index]['ItemTitle'].toString() + '',
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 16.0
                                                        ),
                                                      ),
                                                      SizedBox(height: 5,),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '₹'+snapshot.data.documents[index]['Price'].toString(),
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 18.0,
                                                              color: CommonAssets.pricecolor,
                                                            ),
                                                          ),
                                                          SizedBox(width: 4,),
                                                          EasyRichText(
                                                            '₹'+snapshot.data.documents[index]['MRP'].toString(),
                                                            patternList: [
                                                              EasyRichTextPattern(
                                                                targetString: '₹'+snapshot.data.documents[index]['MRP'].toString(),
                                                                subScript: true,
                                                                //Only TM after Product will be modified
                                                                stringBeforeTarget: 'Product',
                                                                //There is no space between Product and TM
                                                                matchWordBoundaries: false,
                                                                style: TextStyle(
                                                                    color: CommonAssets.mrpcolor,
                                                                    decoration: TextDecoration.lineThrough,
                                                                    fontSize: 17.0
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(width: 4,),
                                                          Text(
                                                            'Save '+'₹'+saveamount.toString(),
                                                            style: TextStyle(

                                                              fontSize: 14.0,
                                                              color: CommonAssets.savepricecolor,
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                      SizedBox(height: 5,),
                                                      // Text(
                                                      //   'Free Delivery',
                                                      //   style: TextStyle(
                                                      //
                                                      //     fontSize: 15.0,
                                                      //
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                  ),
                                )
                              ],
                            ),
                          ),




                        );
                        }
                        else{
                          return CircularLoading();
                        }
                      }
                  );
                }
              else{
                return CircularLoading();
              }
            }
      ),
      drawer: PagesDrawer(controller: controller,page: _pageprovider.page,currentpage: 'Home',),
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