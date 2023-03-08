import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'VetProfile.dart';

class NavBarClinics extends StatelessWidget {
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
            /*currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('android/Images/logo.png',
                  fit: BoxFit.fitHeight,
                  width: 110,
                  height: 110,
                ),
              ),
            ),
            */decoration: BoxDecoration(
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
         /* ListTile(
            leading: Icon(Icons.ballot_outlined,color: Colors.white,),
            title: Text('Find Vets',style: TextStyle(
    color: Colors.white,
    )),
            onTap: () => null,
          ),*/
/*
          ListTile(
            leading: Icon(Icons.notifications,color: Colors.white,),
            title: Text('Notifications',style: TextStyle(
    color: Colors.white,
    )),
          ),
          ListTile(
            leading: Icon(Icons.location_on,color: Colors.white,),
            title: Text('Your Addresses',style: TextStyle(
              color: Colors.white,
            )),
          ),*/
         /* ListTile(
            leading: Icon(Icons.list_alt_outlined,color: Colors.white,),
            title: Text('Reminders',style: TextStyle(
              color: Colors.white,
            )),
          ),
         */ ListTile(
            leading: Icon(Icons.settings,color: Colors.white,),
            title: Text('Settings',style: TextStyle(
              color: Colors.white,
            )),
            onTap: () => null,
          ),
          /*ListTile(
            leading: Icon(Icons.description,color: Colors.white,),
            title: Text('Policies',style: TextStyle(
              color: Colors.white,
            )),
            onTap: () => null,
          ),
          */Divider(),
         /* ListTile(
            title: Text('Logout',style: TextStyle(
              color: Colors.white,
            )),
            leading: Icon(Icons.exit_to_app,color: Colors.white,),
            onTap: () async {
              //FirebaseAuth.instance.signOut(),
              //FirebaseAuth.instance.signOut(),

              if (user.providerData.first.providerId =="google.com") {
              await FirebaseAuth.instance.signOut().then((value) {
                _googleSignIn
                    .signOut()
                  .then((value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  AuthPage()),
                  );
              });
              });

              } else if (user.providerData.first.providerId =="password") {
              await FirebaseAuth.instance.signOut()
                  .then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  AuthPage()),
                );


              });
              }
            }
          ),*/

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