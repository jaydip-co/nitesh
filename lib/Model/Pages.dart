import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class PageProvider extends ChangeNotifier{
  String page = 'Home';
  String previouspage = 'Home';

  setpages(String pagename,String previousPagename){
    page = pagename;
    previouspage=  previousPagename;
    /*print('main =$page');
    print('back = $previouspage');*/


    notifyListeners();

  }

}
