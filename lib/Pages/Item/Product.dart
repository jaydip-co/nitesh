import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nitesh/Model/Appbar.dart';
import 'package:nitesh/Model/Product.dart';
import 'package:nitesh/Shared/Drawer.dart';
import 'package:nitesh/Shared/Loading.dart';
import 'package:provider/provider.dart';

class Product extends StatefulWidget {
  String productname;
  Product({this.productname});
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  int selectedimage  = 0;
  List<String> _category = List() ;
  List<String> _color = List();
  String _selectedcategory;
  String _selectedcolor;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   final ref =  Firestore.instance.collection('SellerProduct').document(widget.productname.toString()).snapshots();
 void date =  ref.forEach((element) {
   for(var i =0;i<element.data['Category'].length;i++)
     {
        _category.add(element.data['Category'][i]);
     }
   for(var j =0;j<element.data['Color'].length;j++)
   {
     _color.add(element.data['Color'][j]);
   }
 });

  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width ;
    final height = MediaQuery.of(context).size.height ;

    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('SellerProduct').document(widget.productname.toString()).snapshots(),
      builder: (context,snapshot){
        if(snapshot.hasData)
          {
          _selectedcategory = _category[0];
          _selectedcolor = _color[0];
            return Scaffold(
              appBar: appbarWWidget(),

              body: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,

                    children: [

                      Container(
                        width: width,
                        height: height/ 3 ,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                          
                        ),

                        child:Row(

                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: (){
                                   setState(() {
                                     if(selectedimage > 0)
                                       {
                                         selectedimage = selectedimage - 1;
                                       }
                                   });
                                  },
                                  icon:selectedimage > 0? Icon(Icons.arrow_back):Icon(Icons.repeat,color: Colors.transparent,),
                                )
                              ],
                            ),
                            Container(

                              child: Expanded(
                                child: Image(
                                  image: NetworkImage(snapshot.data['Images'][selectedimage]),
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: (){

                                     if(selectedimage < snapshot.data['Images'].length -1)
                                       {
                                         setState(() {
                                           selectedimage = selectedimage + 1;
                                         });

                                       }

                                  },
                                  icon: selectedimage < snapshot.data['Images'].length-1 ? Icon(Icons.arrow_forward):Icon(Icons.repeat,color: Colors.transparent,),
                                )
                              ],
                            )
                          ],
                        )
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Category'),
                          ),
                          Expanded(
                            child: Text('Color'),
                          ),
                        ],
                      ),
                      Row(
                        
                        children: [
                          Expanded(
                            child: DropdownButtonFormField(
                              onChanged: (val){
                                setState(() {
                                  _selectedcategory = val;
                                });
                              },
                              value: _selectedcategory,
                              items: _category.map((e){
                                return DropdownMenuItem(
                                  value: e.toString(),
                                  child: Text(e),
                                );
                              }).toList(),
                            ),
                          ),
                          Expanded(
                            child: DropdownButtonFormField(
                              onChanged: (val){
                                setState(() {
                                  _selectedcolor = val;
                                });
                              },
                              value: _selectedcolor,
                              items: _color.map((e){
                                return DropdownMenuItem(
                                  value: e.toString(),
                                  child: Text(e),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
                ),
              ),
              drawer: PagesDrawer(),
            );
          }
        else{
          return Loading();
        }
      },
    );
  }
}
