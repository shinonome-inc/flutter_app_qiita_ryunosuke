import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';


class TopPage extends StatelessWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
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
          Container(
            child: Center(
              child: Column(
                children: [
                  Expanded(flex: 3, child: Container()),
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
                  Expanded(flex: 4, child: Container()),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'ログイン',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: HexColor('#45970e'),
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(bottom: 60),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'ログインせずに利用する',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
