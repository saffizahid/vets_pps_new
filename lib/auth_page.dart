import 'package:flutter/material.dart';
import 'package:vets_pps_new/sign.up_screen.dart';
import 'package:vets_pps_new/signin_screen.dart';
class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showloginpage= true;
  void toggleScreens(){
    setState(() {
      showloginpage=!showloginpage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showloginpage)
    {return MyAppNew(showRegisterPage: toggleScreens);}
    else{
      return Signup(showloginpage: toggleScreens);
    }
  }
}
