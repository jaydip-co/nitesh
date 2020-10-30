import 'package:flutter/material.dart';
import 'package:nitesh/commonAssets.dart';

class CompanyName extends StatefulWidget {
  @override
  _CompanyNameState createState() => _CompanyNameState();
}

class _CompanyNameState extends State<CompanyName>with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  Animation _animation2;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(duration: Duration(seconds: 4),vsync: this);
    _animation = Tween(begin:0.5,end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn
    ));
    _animation2 = Tween(begin:40.0,end: 50.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn
    ));
  _controller.forward();


  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    print(_animation.value);
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context,Widget child){
        return Scaffold(

          body: Center(
            child: Text(
              'THE ERROR',
              style: TextStyle(
                  color: CommonAssets.appbarTextColor.withOpacity(_animation.value),
                  fontSize: _animation2.value,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        );
      }
    );
  }
}
