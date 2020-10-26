import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nitesh/Model/Pages.dart';
import 'package:nitesh/Pages/Home.dart';
import 'package:nitesh/commonAssets.dart';
import 'package:provider/provider.dart';
class PaymentSuccessful extends StatefulWidget {
  @override
  _PaymentSuccessfulState createState() => _PaymentSuccessfulState();
}

class _PaymentSuccessfulState extends State<PaymentSuccessful> {
  @override
  Widget build(BuildContext context) {
    final _pageprovider = Provider.of<PageProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             Stack(
               alignment: Alignment.center,
               children: <Widget>[

                 Container(
                    width: 250.0,
                   height:250.0,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(150.0)
                    ),
                 ),
                 Icon(
                   Icons.check,
                   color: Colors.white,
                   size: 150.0,
                 ),
               ],
             ),
              SizedBox(height: 30,),

              Text(
                'Payment Successful',
                style: TextStyle(
                  fontSize:  width* 0.07,

                ),
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  RaisedButton(
                    shape: StadiumBorder(),
                      color: CommonAssets.buttonColor,
                      onPressed: (){
                      _pageprovider.setpages('Home', 'Home');
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(

                            Icons.home,
                            color: CommonAssets.buttonTextColor,

                          ),
                          SizedBox(width: 5,),
                          Text(
                              'Home',
                            style: TextStyle(
                              color: CommonAssets.buttonTextColor,
                            ),
                          )
                        ],
                      )
                  ),
                  SizedBox(width: 30,),
                  RaisedButton(
                      shape: StadiumBorder(),
                      color: CommonAssets.buttonColor,
                      onPressed: (){
                         _pageprovider.setpages('Product', 'Home')();
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(

                            Icons.shopping_cart,
                            color: CommonAssets.buttonTextColor,

                          ),
                          SizedBox(width: 5,),
                          Text(
                            'Order',
                            style: TextStyle(
                              color: CommonAssets.buttonTextColor,
                            ),
                          )
                        ],
                      )
                  )
                ],
              )
            ],
        ),
      ),
    );
  }
}
