import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nitesh/Common/CircularProgressIndicotr.dart';
import 'package:nitesh/Model/Appbar.dart';
import 'package:nitesh/Model/Pages.dart';
import 'package:nitesh/Model/Product.dart';
import 'package:nitesh/Pages/Item/Product.dart';
import 'package:nitesh/Service/Stream.dart';
import 'package:nitesh/Shared/Drawer.dart';
import 'package:nitesh/Shared/Loading.dart';
import 'package:nitesh/commonAssets.dart';
import 'package:provider/provider.dart';
class UserOrderDetails extends StatefulWidget {
  @override
  _UserOrderDetailsState createState() => _UserOrderDetailsState();
}

class _UserOrderDetailsState extends State<UserOrderDetails> {
  @override
  Widget build(BuildContext context) {
    final _userorderIdprovider = Provider.of<TempProduct>(context);
    final _pageProvider = Provider.of<PageProvider>(context);
    final _tempproduct = Provider.of<TempProduct>(context);

    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: (){
      return  _pageProvider.setpages(_pageProvider.previouspage, _pageProvider.page);
      },
      child: Scaffold(
        appBar: appbarWWidget(),
        body: StreamBuilder<DocumentSnapshot>(
          stream: OrderId(Order_Id: _userorderIdprovider.OrderId).ORDERIDSTREAM,
          builder: (BuildContext context,OrderIdSnapshot){
              if(OrderIdSnapshot.hasData)
                {
                  Timestamp t = OrderIdSnapshot.data['OrderDate'];
                  DateTime d = t.toDate();
                  Timestamp de;
                  DateTime delivery;
                  if(OrderIdSnapshot.data['DeliveryDate'] != 'null')
                    {
                       de = OrderIdSnapshot.data['DeliveryDate'];
                        delivery = de.toDate();
                    }

                    return StreamBuilder<DocumentSnapshot>(
                      stream: ProductStream(product: OrderIdSnapshot.data['ItemName']).PRODUCTSTREAM,
                      builder:(context,OrderItemSnapshot){
                        if(OrderItemSnapshot.hasData)
                          {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(

                                  children: [

                                    Card(
                                      shape: RoundedRectangleBorder(
                                        side: new BorderSide(color: CommonAssets.cardborder, width: 0.3),
                                        borderRadius: BorderRadius.circular(4.0)
                                      ),
                                      child: ListTile(
                                        title: Text('Order Details'),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 8,),
                                            Text('Order Date              '+d.toString().substring(0,10)),
                                            Text('Order Id                  '+_userorderIdprovider.OrderId),
                                            Text('Order Total              '+'₹'+ OrderIdSnapshot.data['GivenAmount'].toString()+'('+'Qty:'+OrderIdSnapshot.data['Quantity'].toString() +')'),
                                          ],
                                        ),
                                      )
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                          side: new BorderSide(color: CommonAssets.cardborder, width: 0.3),
                                          borderRadius: BorderRadius.circular(4.0)
                                      ),
                                      child: ListTile(
                                        title: Text('Shipment Details'),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 8,),
                                            OrderIdSnapshot.data['DeliveryDate'] != 'null'?
                                            Text('Delivery Date             '+delivery.toString().substring(0,10),
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w500,
                                                color: CommonAssets.cardTextColor
                                              )
                                              ,)
                                                : Text('Delivery Date              '+'Not Delivered At',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: CommonAssets.cardTextColor
                                              ),),
                                              SizedBox(height: 5,),
                                            Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5.0),
                                                side: new BorderSide(color: Colors.black, width: 0.05),
                                              ),
                                              child:  ListTile(
                                                leading: GestureDetector(
                                                  onTap: (){
                                                    _tempproduct.setProduct(OrderIdSnapshot.data['ItemName']);
                                                    _pageProvider.setpages('Product', _pageProvider.page);
                                                  },
                                                  child: ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                      minWidth: 80,
                                                      minHeight: 80,
                                                      maxWidth: 120,
                                                      maxHeight: 120,
                                                    ),
                                                    child: Image.network(OrderItemSnapshot.data["Images"][0], fit: BoxFit.cover),
                                                  ),
//                                            Image(
//                                              image: NetworkImage(itemsnapshot.data["Images"][0]),
//                                            ),
                                                ),
                                                title:Text(
                                                  OrderItemSnapshot.data['ItemTitle']??'Title Miss',
                                                  style: TextStyle(
                                                      color: CommonAssets.cardTextColor,
                                                      fontWeight: FontWeight.w500
                                                  ),
                                                ),
                                                subtitle: Text('Qty  '+ OrderIdSnapshot.data['Quantity'].toString()),

                                              ),
                                            ),
                                            Text('Color'),
                                            Container(
                                              height: 15,
                                              width: width *0.3,
                                              decoration: BoxDecoration(
                                                color: Color(int.parse(OrderIdSnapshot.data['Color']))
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ),
                                    Card(
                                        shape: RoundedRectangleBorder(
                                            side: new BorderSide(color: CommonAssets.cardborder, width: 0.3),
                                            borderRadius: BorderRadius.circular(4.0)
                                        ),
                                        child: ListTile(
                                          title: Text('Shipping Address'),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 8,),
                                              Text(OrderIdSnapshot.data['First'].toString()+' '+OrderIdSnapshot.data['Middle'].toString()+' '+OrderIdSnapshot.data['Last'].toString()),
                                              SizedBox(height: 5,),
                                              Text(OrderIdSnapshot.data['Address'].toString()),
                                              SizedBox(height: 5,),
                                              Text(OrderIdSnapshot.data['City'].toString()),
                                              SizedBox(height: 5,),
                                              Text(OrderIdSnapshot.data['Pincode'].toString()),
                                              SizedBox(height: 5,),
                                            ],
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        else{
                         return  Center(child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                            backgroundColor: CommonAssets.buttonColor,

                          ));
                        }
                      }
                    );
                }
              else{
                 return CircularLoading();
              }
          }
        ),
        drawer: PagesDrawer(),
      ),
    );

  }
}
// documentid
// Category
// Color
// GivenAmount
// First
// Last
// Middle
// City
// Address
// Pincode
// Orderdate
// Deliverydate
// Paymentid