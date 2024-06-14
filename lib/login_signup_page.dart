import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isPasswordVisible = false;

  Future<void> signInWithEmailAndPassword() async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User signed in: ${credential.user?.email}');
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple, // Make appbar transparent
        elevation: 0, // Remove appbar elevation
        leading: IconButton(
          color: Colors.black,
          icon: Icon(
            Icons.arrow_back,
            size: 40,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: Text(
          'Login',
          style: GoogleFonts.lobster(
            fontSize: 40,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue, Colors.teal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20),
                  _buildTextField(
                    labelText: 'Email',
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    labelText: 'Password',
                    obscureText: !_isPasswordVisible,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 40),
                  _buildLoginButton(),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                    child: Text(
                      'Create New Account',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    bool obscureText = false,
    required ValueChanged<String> onChanged,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6), // Transparent with white tint
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.purpleAccent.withOpacity(0.4),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        obscureText: obscureText,
        style: TextStyle(color: Colors.white), // Text color
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle:
              TextStyle(color: Colors.black.withOpacity(1)), // Label color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Material(
      elevation: 10,
      shadowColor: Colors.black.withOpacity(1),
      borderRadius: BorderRadius.circular(30),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.withOpacity(0.8), Colors.orange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: InkWell(
          onTap: () {
            signInWithEmailAndPassword();
          },
          borderRadius: BorderRadius.circular(30),
          child: Container(
            alignment: Alignment.center,
            width: 180,
            height: 50,
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
