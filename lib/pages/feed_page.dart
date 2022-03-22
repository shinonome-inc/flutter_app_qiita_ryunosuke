import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  Widget _textField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 36.0,
      width: double.infinity,
      child: TextFormField(
        decoration:  const InputDecoration(
          prefixIcon: Icon(Icons.search),
          labelText: 'Search',
          filled: true,
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Feed',
          style: GoogleFonts.pacifico(
            color: Colors.black,
            fontSize: 17.0,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(27.0),
          child: Column(
            children: [
              _textField(),
              const Divider(height: 1),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Container(
        ),
      ),
    );
  }
}
