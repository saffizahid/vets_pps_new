/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class WalletScreen extends StatelessWidget {
  Map userMap;
  User user;
  WalletScreen({Key? key,required this.userMap,required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wallet"),centerTitle: true,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text(userMap["wallet"].toString(),style: TextStyle(fontSize: 25),),),
          SizedBox(height: 0.2.sh,),
          ListTile(leading: Text("Name"),trailing: Text(userMap["firstname"]),),
          ListTile(leading: Text("Email"),trailing: Text(user.email!),),
          ListTile(leading: Text("phone"),trailing: Text(userMap["phnumber"]),),
          ListTile(leading: Text("CNIC"),trailing: Text(userMap["CNIC"]),),
        ],
      ),
    );
  }
}
*/
