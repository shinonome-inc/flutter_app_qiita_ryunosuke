import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class TagPage extends StatefulWidget {
  const TagPage({ Key? key }): super(key: key);
  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottomOpacity: 0.0,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
              'Tags',
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
      ),
    );
  }
}
