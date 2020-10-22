import 'package:flutter/cupertino.dart';

class TempProduct extends ChangeNotifier {
  String productName ;

    setProduct(String products){
      productName = products;
    //  print(productName);
      notifyListeners();
    }


}