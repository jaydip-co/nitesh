import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nitesh/Pages/Home.dart';
import 'package:nitesh/Service/AuthService.dart';
import 'package:nitesh/Service/Database.dart';
import 'package:nitesh/Shared/Inputdecoration.dart';
import 'package:nitesh/commonAssets.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String number;
  String mobile; // without country code
  String code = '+91';
  bool autovalidate = false;
  final _formkey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  Future<bool> logInWithMobile(String phonenumber,BuildContext context)async
  {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: number,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async{
          Navigator.of(context).pop();

          AuthResult result = await _auth.signInWithCredential(credential);
          FirebaseUser user = result.user;
          DatabaseService(number:number).newUser();
          return AuthService().firebaseUser(user);



          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (AuthException exception){
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]){
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Give the code?"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        decoration:inputdecoration.copyWith(
                          labelText: 'OTP',
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green),borderRadius: BorderRadius.circular(20.0)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green),borderRadius: BorderRadius.circular(20.0)),
                          /*focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),*/
                          labelStyle: TextStyle(color:CommonAssets.labelTextColor),
                        ),
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Confirm",style: TextStyle(
                          color: CommonAssets.flatbuttonTextColor
                      ),),
                      textColor: Colors.white,

                      onPressed: () async{
                        final code = _codeController.text.trim();
                        AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: code);
                        AuthResult result = await _auth.signInWithCredential(credential);
                        FirebaseUser user = result.user;
                        Navigator.of(context).pop();
                        DatabaseService(number: number).newUser();
                        AuthService().MobileNumberColl(mobile);
                        return AuthService().firebaseUser(user);


                      },
                    )
                  ],
                );
              }
          );
        },
        codeAutoRetrievalTimeout: null
    );
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.fromLTRB(width * 0.1,height * 0.1,width * 0.1,height * 0.2),
          child: Container(
            width: width * 0.80 ,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    'SignIn',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                    color: CommonAssets.appbarTextColor,
                    fontFamily:   ''
                  ),
                ),
                SizedBox(height: 50,),
                Form(
                  key: _formkey,
                  autovalidate: autovalidate,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        cursorColor: CommonAssets.cursorcolor,
                        keyboardType: TextInputType.phone,
                        onChanged: (val) {
                          mobile = val;
                          number = "+91"+ val;


                        } ,
                        validator: numberValidation,
                        decoration:inputdecoration.copyWith(
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green),borderRadius: BorderRadius.circular(20.0)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green),borderRadius: BorderRadius.circular(20.0)),
                          focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red),borderRadius: BorderRadius.circular(20.0)),
                          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red),borderRadius: BorderRadius.circular(20.0)),
                          labelStyle: TextStyle(color:CommonAssets.labelTextColor),
                        ),
                      ),
                      SizedBox(height: 20,),
                      RaisedButton(

                        shape: StadiumBorder(),
                        padding: EdgeInsets.fromLTRB(40.0,20.0,40.0,20.0),
                        color: CommonAssets.buttonColor,
                        child: Text(
                          'LogIn',
                          style: TextStyle(
                              fontSize: 16,
                              color: CommonAssets.buttonTextColor
                          ),
                        ),
                        onPressed: ()async{
                          print(number);
                          if(_formkey.currentState.validate())
                          {
                            await logInWithMobile(number, context);
                          }
                          else{
                            setState(() {
                              autovalidate = true;
                            });
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
String numberValidation(String number ){
  Pattern pattern = r'^[0-9]{10}$';
  RegExp regExp = new RegExp(pattern);
  if(!regExp.hasMatch(number)){
    return "Enter The Valid Number";
  }
  else{
    return null;
  }
}
