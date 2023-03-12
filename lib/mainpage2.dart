import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Authntication/auth_page.dart';
import 'CLINICVETS/home_screen_clinics.dart';
import 'VETATHOME/home_screen_vetathome.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('login')
                  .doc(user.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data!.exists &&
                    snapshot.data!['Profile'] == 'Clinic') {
                  return HomePageClinics();
                } else if (snapshot.hasData &&
                    snapshot.data!.exists &&
                    snapshot.data!['Profile'] == 'VETATHOME') {
                  return HomePageVetAtHome();
                } else {
                  return AuthPage();
                }
              },
            );
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}
