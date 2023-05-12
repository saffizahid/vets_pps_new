import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Common/VetProfile.dart';
import '../Payment/Wallet/UserWallet.dart';
import '../Payment/Wallet/UserWalletVAH.dart';
import '../mainpage2.dart';

class NavBarVAH extends StatelessWidget {
  final user= FirebaseAuth.instance.currentUser!;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );
  @override
  Widget build(BuildContext context) {
    return
      Drawer(
      backgroundColor: Color.fromRGBO(26, 59, 106, 0.8745098039215686),

      child: ListView(

        // Remove padding
        padding: EdgeInsets.zero,
        children: [

          UserAccountsDrawerHeader(
            accountName: Text('Hi, '+ user.email!,style: TextStyle(
              color: Colors.white,
            )),
            accountEmail: Text('How is Your Pet Health?' ,style: TextStyle(
              color: Colors.white,
            )),
           decoration: BoxDecoration(
              //color:Color.fromRGBO(26, 59, 106, 0.023529411764705882),
            ),
          ),

          ListTile(
            leading: Icon(Icons.person,color: Colors.white,),
            title: Text('Profile',style: TextStyle(
              color: Colors.white,
            )),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return UserdetailsPage(ProfileType: "VETATHOME",);
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet,color: Colors.white,),
            title: Text('Wallet',style: TextStyle(
              color: Colors.white,
            )),
            onTap: (){
              FirebaseFirestore.instance.collection("vet_wallet").doc(user.uid).get().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context)
                        {
                          return  WalletScreen(ProfileType: 'VETATHOME',);
                        }
                    )
                );
              });

            },),

          ListTile(
            leading: Icon(Icons.settings,color: Colors.white,),
            title: Text('Settings',style: TextStyle(
              color: Colors.white,
            )),
            onTap: () => null,
          ),
          Divider(),

          ListTile(
            title: Text('Logout',style: TextStyle(
              color: Colors.white,
            )),
            leading: Icon(Icons.exit_to_app,color: Colors.white,),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
                    (route) => false,
              );
            }, ),
        ],
      ),
    );
  }

}