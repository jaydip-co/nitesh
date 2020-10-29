import 'package:flutter/material.dart';
import 'package:nitesh/Model/Pages.dart';
import 'package:nitesh/Model/Product.dart';
import 'package:nitesh/Model/User.dart';

import 'package:nitesh/Pages/Home.dart';
import 'package:nitesh/Pages/Item/Product.dart';
import 'package:nitesh/Pages/Address.dart';
import 'package:nitesh/Pages/Order/ConfirmDetail.dart';
import 'package:nitesh/Pages/Order/UserOrder.dart';
import 'file:///D:/app/nitesh/lib/Pages/Order/UserOrderDetails.dart';
import 'package:provider/provider.dart';
class PagesWrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _pageprovider =  Provider.of<PageProvider>(context);
    final _product = Provider.of<TempProduct>(context);
    final _user = Provider.of<User>(context,listen: false);
   // print('page');
   // print(_pageprovider.page);
    if(_pageprovider.page == 'Home'){
      return new Home();
    }
    else if(_pageprovider.page == 'UserOrder'){
      return new UserOrder();
    }
    else if(_pageprovider.page == 'Order'){
      String number = _user.UserNumber;

      return new Order(number: number);
    }
    else if(_pageprovider.page == 'Product'){
      return new Product();
    }//UserOrderDetails
    else if(_pageprovider.page == 'ConfirmDetails'){

      return new ConfirmDetails();
    }
    else if(_pageprovider.page == 'UserOrderDetails'){
      return new UserOrderDetails();
    }
    else{//OrderDetails
      return  new Home();
    }

  }
}
