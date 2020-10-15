import 'package:flutter/material.dart';
import 'package:nitesh/Service/AuthService.dart';
import 'package:nitesh/Wrapper.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthService().USERSTREAM,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(



          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: new Wrapper()
      ),
    );
  }
}

