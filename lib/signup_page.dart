import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String username = '';
  String email = '';
  String password = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isPasswordVisible = false;

  Future<void> createUserWithEmailAndPassword() async {
    try {
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User registered: ${credential.user?.email}');

      // Store user data in Firestore
      await _firestore.collection('users').doc(credential.user?.uid).set({
        'username': username,
        'email': email,
        // Do not store password in plaintext in Firestore
      });

      // Navigate to home page or any other page
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      print('Error signing up: $e');
      // Handle signup error
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Signup Error'),
          content: Text(e.message ?? 'An error occurred during signup.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
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
          'Sign Up',
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
                    labelText: 'Username',
                    onChanged: (value) {
                      setState(() {
                        username = value;
                      });
                    },
                  ),
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
                  _buildSignupButton(),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      'Already have an account? Login',
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
            blurRadius: 8,
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

  Widget _buildSignupButton() {
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
            createUserWithEmailAndPassword();
          },
          borderRadius: BorderRadius.circular(30),
          child: Container(
            alignment: Alignment.center,
            width: 180,
            height: 50,
            child: Text(
              'Sign Up',
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
