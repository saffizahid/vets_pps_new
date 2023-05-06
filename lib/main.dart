import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'mainpage2.dart';

Future main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
   runApp(MyApp());
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AnimatedSplashScreen(splash:Column(
      children: [
        Image.asset('android/Images/Splash.png',)
      ],
    ),
splashIconSize: 350,
duration: 2000,
splashTransition: SplashTransition.fadeTransition,
backgroundColor: Color.fromRGBO(26, 59, 106, 1.0),
     nextScreen: MainPage());
  }
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: SplashScreen(),
    );
  }
}



