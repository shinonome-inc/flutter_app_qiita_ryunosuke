import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarDesign extends StatelessWidget with PreferredSizeWidget {

  final String text;

  AppBarDesign({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      bottomOpacity: 0.0,
      elevation: 0.0,
      centerTitle: true,
      title: Text(
        text,
        style: GoogleFonts.pacifico(
          fontSize: 17.0,
          color: Colors.black,
        ),
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(55.0);
}
