import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nitesh/Model/Appbar.dart';
import 'package:nitesh/Model/Pages.dart';
import 'package:nitesh/Model/User.dart';
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
              return ListView.builder(
                    itemCount:   Usersnapshot.data['LastOrder'].length ?? 0,
                  itemExtent:150.0,
                  itemBuilder: (context,index){
                    return StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance.collection('Order').document(Usersnapshot.data['LastOrder'][index]).snapshots(),
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
                                          side: new BorderSide(color: Colors.black, width: 0.1),
                                        ),
                                        child: ListTile(
                                          title: Row(
                                            children: <Widget>[
                                            Expanded(
                                              child: Image(
                                                image: NetworkImage(itemsnapshot.data["Images"][0]),
                                              ),
                                            ),
                                              SizedBox(width: 6,),
                                              Expanded(child: Text(itemsnapshot.data['ItemTitle'])
                                              ),
                                            ],
                                          ),
                                          subtitle: Text(d.toString().substring(0,19)),
                                        ),
                                      ),
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
