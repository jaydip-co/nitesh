import 'package:flutter/material.dart';
import 'package:nitesh/Model/Pages.dart';
import 'package:nitesh/Pages/Auth/demo.dart';
import 'package:nitesh/Pages/Home.dart';
import 'package:nitesh/Pages/Order.dart';
import 'package:provider/provider.dart';
class PagesWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _pageprovider =  Provider.of<PageProvider>(context);
   // print(_pageprovider.page);
    if(_pageprovider.page == 'Home'){
      return Home();
    }
    else if(_pageprovider.page == 'Profile'){
      return Demo();
    }
    else if(_pageprovider.page == 'Order'){
      return Order();
    }
    else{
      return Home();
    }

  }
}
