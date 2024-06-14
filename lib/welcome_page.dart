import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent,
              Colors.purpleAccent,
              Colors.redAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 50),
              TransferBackgroundButton(
                text: 'Login',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/login',
                  );
                },
                width: 200, // Adjust the width as needed
              ),
              SizedBox(height: 20),
              TransferBackgroundButton(
                text: 'Sign Up',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/signin',
                  );
                },
                width: 200, // Adjust the width as needed
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransferBackgroundButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width; // Width of the button

  const TransferBackgroundButton({
    required this.text,
    required this.onPressed,
    this.width = 200, // Default width
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.2), // Transparent white background
          border: Border.all(color: Colors.white),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
