import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nitesh/Model/Appbar.dart';
import 'package:nitesh/Model/Pages.dart';
import 'package:nitesh/Model/Product.dart';
import 'package:nitesh/Shared/Drawer.dart';
import 'package:nitesh/Shared/Inputdecoration.dart';
import 'package:nitesh/Shared/Loading.dart';
import 'package:nitesh/commonAssets.dart';
import 'package:provider/provider.dart';

class Product extends StatefulWidget {

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  int selectedimage  = 0;
  List<String> _category = List() ;
  List<String> _color = List();
  String _selectedcategory  ;
  String _selectedcolor ;
  num saveamount ;
  int quantity = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    final ref =    Firestore.instance.collection('SellerProduct').document(widget.productname.toString()).snapshots();
//    void date =  ref.forEach((element) {
//        _list();
//      _category.clear();
//      _color.clear();
//      for(var i =0;i<element.data['Category'].length;i++)
//      {
//        _category.add(element.data['Category'][i]);
//      }
//      for(var j =0;j<element.data['Color'].length;j++)
//      {
//        _color.add(element.data['Color'][j]);
//      }
//
//    });
  }
  void _list()async{
    print('called');
    await   Firestore.instance.collection('Users').document('+919512676561').updateData({
      'demo':FieldValue.serverTimestamp()
    });

  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width ;
    final height = MediaQuery.of(context).size.height ;
    final _pageprovider = Provider.of<PageProvider>(context);
    final _tempProduct = Provider.of<TempProduct>(context);
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('SellerProduct').document(_tempProduct.productName.toString()).snapshots(),
      builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot> snapshot){

        if(snapshot.hasData)
          {
            List<String> _category = List.from(snapshot.data["Category"]);
            List<String> _color = List.from(snapshot.data["Color"]);
            print("jaydip");
//            _category.add(snapshot.data['Category']);
            saveamount =snapshot.data['Price']-snapshot.data['MRP'];
            print(_category);
            //_list();


            return WillPopScope(
              onWillPop: (){
                return _pageprovider.setpages(_pageprovider.previouspage,_pageprovider.page.toString());
              },
              child: Scaffold(
                appBar: appbarWWidget(),

                body: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Container(

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: Text(
                          snapshot.data['ItemTitle'].toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500
                            ),
                        ),
                      ),

                      Container(
                          width: width,
                          height: height / 3,
                          //decoration: BoxDecoration(color: Colors.grey[100]),
                          child: Row(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (selectedimage > 0) {
                                          selectedimage = selectedimage - 1;
                                        }
                                      });
                                    },
                                    icon: selectedimage > 0
                                        ? Icon(Icons.arrow_back)
                                        : Icon(
                                            Icons.repeat,
                                            color: Colors.transparent,
                                          ),
                                  )
                                ],
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(),
                                  child: Image(
                                    image: NetworkImage(
                                        snapshot.data['Images'][selectedimage]),
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (selectedimage <
                                          snapshot.data['Images'].length - 1) {
                                        setState(() {
                                          selectedimage = selectedimage + 1;
                                        });
                                      }
                                    },
                                    icon: selectedimage <
                                            snapshot.data['Images'].length - 1
                                        ? Icon(Icons.arrow_forward)
                                        : Icon(
                                            Icons.repeat,
                                            color: Colors.transparent,
                                          ),
                                  )
                                ],
                              )
                            ],
                          )),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  '₹' + snapshot.data['Price'].toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      'MRP.:',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '₹' + snapshot.data['MRP'].toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          decoration: TextDecoration.lineThrough),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Save ₹' + saveamount.toString(),
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.red),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Category',
                                    style: TextStyle(
                                        fontSize: CommonAssets.fontsizeforlabel),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    'Color',
                                    style: TextStyle(
                                        fontSize: CommonAssets.fontsizeforlabel),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField(
                                    key: UniqueKey(),
                                    decoration: dropdownDecoration,
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedcategory = val;
                                      });
                                    },
                                    value: _selectedcategory ?? _category[0],
                                    items: _category.map((e) {
                                      return DropdownMenuItem(
                                        value: e.toString(),
                                        child: Text(e),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: DropdownButtonFormField(
                                    key: UniqueKey(),
                                    decoration: dropdownDecoration,
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedcolor = val;
                                      });
                                    },
                                    value: _selectedcolor ?? _color[0],
                                    items: _color.map((e) {
                                      return DropdownMenuItem(
                                        value: e.toString(),
                                        child: Text(e),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Text('Quantity'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  onPressed: (){

                                     if(quantity > 1)
                                       {
                                        setState(() {
                                          quantity = quantity - 1;
                                        });
                                       }

                                  },
                                  icon: Icon(Icons.remove),
                                ),
                               Container(
                                 padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(10.0),
                                   border: Border(
                                     top: BorderSide(color: CommonAssets.buttonColor),
                                     bottom: BorderSide(color: CommonAssets.buttonColor),
                                     left: BorderSide(color: CommonAssets.buttonColor),
                                     right: BorderSide(color: CommonAssets.buttonColor),
                                   )
                                 ),
                                 child:  Text(quantity.toString()),
                               ),
                                IconButton(
                                  onPressed: (){
                                    setState(() {
                                      if(quantity < 5){
                                        setState(() {
                                          quantity = quantity + 1;
                                        });
                                      }
                                    });

                                  },
                                  icon: Icon(Icons.add),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            RaisedButton(
                              elevation: 20.0,
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: width * 0.3),
                              splashColor: Colors.black,
                              shape: StadiumBorder(),
                              color: CommonAssets.buttonColor,
                              onPressed: () async{
                                _pageprovider.setpages('ConfirmDetails',_pageprovider.page);
                                _tempProduct.setQuantity(quantity,_selectedcategory ?? _category[0] ,_selectedcolor ?? _color[0]);
                              //  _pageprovider.setpages('Order',_pageprovider.page);
                              },
                              child: Text(
                                'Buy',
                                style: TextStyle(
                                    color: CommonAssets.buttonTextColor,
                                    fontSize: CommonAssets.buttontextsize),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Divider(
                              color: Colors.grey.withOpacity(0.5),
                              thickness: 5.0,
                            ),
                            Text(
                              'Feature & Details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),),
                            Container(
                              width: width,

                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data['Detail'].length,
                                  itemBuilder: (context, index) {
                                    return Row(

                                      children: <Widget>[
                                        Text(
                                          '· ',
                                          style: TextStyle(

                                            fontWeight: FontWeight.bold,
                                            fontSize: 25.0,
                                          ),
                                        ),
                                        Flexible(child:
                                        Text(
                                          snapshot.data['Detail'][index].toString(),
                                          style: TextStyle(

                                            fontSize: 18.0,
                                          ),
                                        )
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),

                    ],
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
      },
    );
  }
}
