import 'dart:convert';

import 'package:http/http.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nitesh/Model/Pages.dart';
import 'package:nitesh/Model/Product.dart';
import 'package:nitesh/Model/User.dart';
import 'package:nitesh/Pages/Auth/LogIn.dart';

import 'package:nitesh/Pages/Home.dart';

import 'package:nitesh/Shared/Loading.dart';
import 'package:nitesh/Shared/PagesWapper.dart';
import 'package:provider/provider.dart';
class Wrapper extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
     final user = Provider.of<User>(context);
      //  return PaymentSuccessful();
     if(user != null){

       return ChangeNotifierProvider<PageProvider>.value(
         value: PageProvider(),
           child: ChangeNotifierProvider<TempProduct>.value(
               value: TempProduct(),
               child: PagesWrapper()));
     }
     else{

       return LogIn();
     }


  }
}
//class TestHome extends StatefulWidget {
//  @override
//  _TestHomeState createState() => _TestHomeState();
//}
//
//class _TestHomeState extends State<TestHome> {
//  String titles = 'normal';
// final FirebaseMessaging mass = FirebaseMessaging();
// final Client client = Client();
//  @override
//  void initState() {
//    customnoto();
//    super.initState();
//    mass.configure(
//      onMessage: (Map<String, dynamic> mess){
//        print(mess.toString());
//      },
//     onResume:  (Map<String, dynamic> mess){
//       print(mess.toString());
//     },
//      onLaunch:  (Map<String, dynamic> mess){
//          setState(() {
//            titles = 'onluch';
//          });
//        print(mess.toString());
//      },
//    );
//
//  }
//  Future customnoto()async{
//    final String serverToken = 'AAAAyDHykpU:APA91bGybaVRBEVIPYjkOwkePEMUg0teZWy_ErEymI5eZXnqDfC1DvuRX1fMbDHmuVAqW-NFRplg1LKIoZSTu8y2z1USUeQfZ1Vt--rMmZomasb0mbf3rLjTzYM7UnBYHAOIM5mU1Zxr';
//    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
//    firebaseMessaging.onTokenRefresh.listen(tokenlistner);
//  String token = await firebaseMessaging.getToken();
//  print (token);
//      firebaseMessaging.subscribeToTopic('all');
//    await client.post(
//      'https://fcm.googleapis.com/fcm/send',
//      headers: <String, String>{
//        'Content-Type': 'application/json',
//        'Authorization': 'key=$serverToken',
//      },
//      body: jsonEncode(
//        <String, dynamic>{
//          'notification': <String, dynamic>{
//            'body': 'this is a ABHAY',
//            'title': 'this is a THE',
//
//          },
//          'priority': 'high',
//          'data': <String, dynamic>{
//            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//            'id': '1',
//            'status': 'done'
//          },
//          'to':'/topics/all',
//        },
//      ),
//    );
//  }
//   tokenlistner(String token){
//    print('token - $token');
//   }
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//    appBar: AppBar(
//      title: RaisedButton(
//        onPressed: ()async{
//        await  customnoto();
//        },
//        child: Text('s'),
//      ),
//    ),
//    );
//  }
//}


