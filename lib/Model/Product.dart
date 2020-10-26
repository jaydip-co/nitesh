import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class TempProduct extends ChangeNotifier {
  String productName ;
  int Quantity;
 String Category ;
 String ItemColor;
    setProduct(String products){
      productName = products;
    //  print(productName);
      notifyListeners();
    }
    setQuantity(int quantity,String category,String color)
    {
    Quantity =quantity;
    Category =category;
    ItemColor= color;
    notifyListeners();
    print('Quantity = '+Quantity.toString());
    print('Category = '+Category.toString());
    print('Color = '+ItemColor.toString());

    }

}