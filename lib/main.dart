import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(
    const MaterialApp(
      home: LoginPage(),
    ),
);

class LoginPage extends StatelessWidget {
  const LoginPage ({ Key? key }): super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'images/qiita.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
                child: Column(
                  children: [
                    Text(
                        'Qiita Feed App',
                      style: GoogleFonts.pacifico(
                        fontSize: 40.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                        '-PlayGround-',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
            ),
          ]
        ),
      ),
    );
  }
}



