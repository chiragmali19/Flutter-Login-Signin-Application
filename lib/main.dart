import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login_signin/home_page.dart';
import 'package:login_signin/login_signup_page.dart';
import 'package:login_signin/signup_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Login/Signup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/signin': (context) => SignupPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
