import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Mypage extends StatefulWidget {
  const Mypage({ Key? key }): super(key: key);
  @override
  _MypageState createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottomOpacity: 0.0,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'MyPage',
            style: GoogleFonts.pacifico(
              fontSize: 17.0,
              color: Colors.black,
            ),
          ),
          bottom: const PreferredSize(
            child: Divider(
              color: Colors.black,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(1.0),
          ),
        ),
        body: Container(),
      );
  }
}
