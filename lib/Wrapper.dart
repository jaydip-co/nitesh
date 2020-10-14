import 'package:flutter/material.dart';
import 'package:nitesh/Model/Pages.dart';
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
    final user = Provider.of<User>(context);

    if(user != null){

      return ChangeNotifierProvider<PageProvider>.value(
        value: PageProvider(),
          child: PagesWrapper());
    }
    else{

      return LogIn();
    }

  }
}
