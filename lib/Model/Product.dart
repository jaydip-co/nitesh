import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class TempProduct extends ChangeNotifier {
  String productName ;
  int Quantity;
 String Category ;
 String ItemColor;
 String OrderId;//OrderNUmber for custom to track the order
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
//    print('Quantity = '+Quantity.toString());
//    print('Category = '+Category.toString());
//    print('Color = '+ItemColor.toString());
    }

    setOrderNumber(String ordernumber){
      OrderId = ordernumber;
      // print(OrderId);
      // notifyListeners();
    }

}