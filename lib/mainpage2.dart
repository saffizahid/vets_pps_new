import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vets_pps_new/CLINICVETS/home_screen_clinics.dart';
import 'package:vets_pps_new/VetAtHome/home_screen_vetathome.dart';

import 'Authntication/auth_page.dart';


class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user= FirebaseAuth.instance.currentUser!;

    return  Scaffold(
      body: StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(),
      builder:(context, snapshot){
        if (snapshot.hasData)
        {return   StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("login")
              .doc(user.uid)
              .snapshots(),
          builder: (context, sasapshot) {
            if (sasapshot.hasError) {
              return Text('Error: ${sasapshot.error}');
            }
            if (!sasapshot.hasData || sasapshot.data == null) {
              return CircularProgressIndicator();
            }
            final data = sasapshot.data!.data();
            if (data == null) {
              return Text('No data found');
            }
            final profile = data['Profile'];
            if (profile == "vetathome") {
              return  HomePageVetAtHome();}
            //CLINIC HOME
            else {
              return HomePageClinics();
            }
          },

        );
        }
        else {
          return  AuthPage();
        }
      },
      )
    );

  }
}
