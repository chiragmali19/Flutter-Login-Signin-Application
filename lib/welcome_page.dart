import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.deepPurple,
              Colors.black,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.music_note,
                color: Colors.deepPurpleAccent,
                size: 100,
                shadows: [
                  Shadow(
                    blurRadius: 20.0,
                    color: Colors.deepPurpleAccent,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Welcome to Music World',
                style: GoogleFonts.lobster(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.deepPurpleAccent,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Feel the Rhythm!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.deepPurpleAccent,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              TransferBackgroundButton(
                text: 'Login',
                icon: Icons.login,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/login',
                  );
                },
              ),
              SizedBox(height: 20),
              TransferBackgroundButton(
                text: 'Sign Up',
                icon: Icons.person_add,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/signin',
                  );
                },
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
  final IconData icon;
  final VoidCallback onPressed;

  const TransferBackgroundButton({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color:
              Colors.deepPurple.withOpacity(0.3), // Transparent dark background
          border: Border.all(color: Colors.deepPurpleAccent),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.8),
              blurRadius: 20,
              offset: Offset(5, 5),
            ),
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.5),
              blurRadius: 20,
              offset: Offset(-5, -5),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.deepPurpleAccent,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.deepPurpleAccent,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
