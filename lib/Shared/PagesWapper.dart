import 'package:flutter/material.dart';
import 'package:nitesh/Model/Pages.dart';
import 'package:nitesh/Model/User.dart';
import 'package:nitesh/Pages/Auth/demo.dart';
import 'package:nitesh/Pages/Home.dart';
import 'package:nitesh/Pages/Order.dart';
import 'package:provider/provider.dart';
class PagesWrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _pageprovider =  Provider.of<PageProvider>(context);
    final _user = Provider.of<User>(context);
   // print('page');
    //print(_pageprovider.page);
    if(_pageprovider.page == 'Home'){
      return new Home();
    }
    else if(_pageprovider.page == 'Profile'){
      return new Demo();
    }
    else if(_pageprovider.page == 'Order'){
      String number = _user.UserNumber;

      return new Order(number: number);
    }
    else{
      return  new Home();
    }

  }
}
