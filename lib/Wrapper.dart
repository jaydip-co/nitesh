import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nitesh/Model/Pages.dart';
import 'package:nitesh/Model/Product.dart';
import 'package:nitesh/Model/User.dart';
import 'package:nitesh/Pages/Auth/LogIn.dart';
import 'package:nitesh/Pages/Auth/demo.dart';
import 'package:nitesh/Pages/Home.dart';
import 'package:nitesh/Shared/Loading.dart';
import 'package:nitesh/Shared/PagesWapper.dart';
import 'package:provider/provider.dart';
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User>(context);
    //
    // if(user != null){
    //
    //   return ChangeNotifierProvider<PageProvider>.value(
    //     value: PageProvider(),
    //       child: ChangeNotifierProvider<TempProduct>.value(
    //           value: TempProduct(),
    //           child: PagesWrapper()));
    // }
    // else{
    //
    //   return LogIn();
    // }
    return TestHome();

  }
}
class TestHome extends StatefulWidget {
  @override
  _TestHomeState createState() => _TestHomeState();
}

class _TestHomeState extends State<TestHome> {
 final FirebaseMessaging mass = FirebaseMessaging();
  @override
  void initState() {

    super.initState();
    mass.configure(
      onMessage: (ma){
        print("$ma");
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}


