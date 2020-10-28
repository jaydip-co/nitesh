import 'package:flutter/material.dart';
import 'package:nitesh/commonAssets.dart';
class CircularLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
          semanticsLabel:'Loading' ,
          valueColor:AlwaysStoppedAnimation<Color>(CommonAssets.loadingcolor),

            backgroundColor: CommonAssets.loadingbackground
        ));
  }
}
