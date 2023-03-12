import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../CLINICVETS/VetProfile.dart';

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
                return UserdetailsPage();
              }));
            },
          ),
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
            onTap: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
    );
  }

}