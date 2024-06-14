import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login_signin/login_signup_page.dart';
import 'package:login_signin/profile_page.dart';
import 'package:login_signin/signup_page.dart';
import 'package:login_signin/welcome_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: PlayIntegrityProvider(), // For Android
  );
  runApp(MyApp());
}

// Corrected PlayIntegrityProvider function
AndroidProvider PlayIntegrityProvider() {
  return AndroidProvider.playIntegrity;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Login/Signup',
        initialRoute: '/',
        routes: {
          '/': (context) => WelcomePage(),
          '/login': (context) => LoginPage(),
          '/signin': (context) => SignupPage(),
          '/home': (context) => ProfilePage(),
        });
  }
}
