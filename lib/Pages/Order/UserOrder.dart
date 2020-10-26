import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nitesh/Model/Appbar.dart';
import 'package:nitesh/Model/Pages.dart';
import 'package:nitesh/Model/Product.dart';
import 'package:nitesh/Model/User.dart';
import 'package:nitesh/Pages/Address.dart';
import 'package:nitesh/Shared/Drawer.dart';
import 'package:nitesh/Shared/Loading.dart';
import 'package:nitesh/commonAssets.dart';
import 'package:provider/provider.dart';
class UserOrder extends StatefulWidget {
  @override
  _UserOrderState createState() => _UserOrderState();
}

class _UserOrderState extends State<UserOrder> {
  @override
  Widget build(BuildContext context) {
      final _userprovider = Provider.of<User>(context);
    final _pageprovider = Provider.of<PageProvider>(context);
      final _tempproduct = Provider.of<TempProduct>(context);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: (){
        return _pageprovider.setpages(_pageprovider.previouspage,_pageprovider.page.toString());
      },
      child: Scaffold(
        appBar: appbarWWidget(),
        body: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection('Users').document(_userprovider.UserNumber).snapshots(),
          builder: (context,Usersnapshot){
            if(Usersnapshot.hasData){
              List<String> userOrder = List.from(Usersnapshot.data['LastOrder']);
              userOrder.sort((a, b) => b.compareTo(a));
              print(userOrder);

              return ListView.builder(
                    itemCount:   Usersnapshot.data['LastOrder'].length ?? 0,

                  itemBuilder: (context,index){
                    return StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance.collection('Order').document(userOrder [index]).snapshots(),
                      builder: (context,OrdeSnapshot){
                        if(OrdeSnapshot.hasData)
                          {
                            return StreamBuilder<DocumentSnapshot>(
                                stream: Firestore.instance.collection('SellerProduct').document(OrdeSnapshot.data['ItemType']).snapshots(),
                                builder:(context,itemsnapshot){

                                  if(itemsnapshot.hasData){
                                    Timestamp t = OrdeSnapshot.data['OrderDate'];
                                    DateTime d = t.toDate();
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                          side: new BorderSide(color: Colors.black, width: 0.3),
                                        ),
                                        child:Column(
                                          children: <Widget>[
                                            Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5.0),
                                                side: new BorderSide(color: Colors.black, width: 0.1),
                                              ),
                                              child:  ListTile(
                                                leading: GestureDetector(
                                                  onTap: (){
                                                    _tempproduct.setProduct(itemsnapshot.data.documentID);
                                                    _pageprovider.setpages('Product', _pageprovider.page);
                                                  },
                                                  child: ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                      minWidth: 80,
                                                      minHeight: 80,
                                                      maxWidth: 120,
                                                      maxHeight: 120,
                                                    ),
                                                    child: Image.network(itemsnapshot.data["Images"][0], fit: BoxFit.cover),
                                                  ),
//                                            Image(
//                                              image: NetworkImage(itemsnapshot.data["Images"][0]),
//                                            ),
                                                ),
                                                title:Text(
                                                    itemsnapshot.data['ItemTitle']??'Title Miss',
                                                  style: TextStyle(
                                                    color: CommonAssets.cardTextColor,
                                                    fontWeight: FontWeight.w500
                                                  ),
                                                ),
                                                subtitle: Text(d.toString().substring(0,19)?? 'Date Miss'),
                                              ),
                                            ),
                                            GestureDetector(
                                                onTap: (){

                                                },
                                              child: ListTile(
                                                title: Text('View Order Details'),
                                              ),
                                            )
                                          ],
                                        )

                                      )

                                    );
                                  }
                                  else{
                                    return Loading();
                                  }
                                }
                            );
                          }else{
                          return Loading();
                        }
                      }
                    );

              });
            }
            else{
              return Loading();
            }
          }
        ),
        drawer: PagesDrawer(page: _pageprovider.page,),
      ),
    );
  }
}
