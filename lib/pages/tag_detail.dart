import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/tag.dart';

class TagDetail extends StatefulWidget {
  final Tag tag;
  const TagDetail({Key? key, required this.tag}) : super(key: key);

  @override
  State<TagDetail> createState() => _TagDetailState();
}

class _TagDetailState extends State<TagDetail> {
  String tagId = '';

  @override
  void initState() {
    tagId = widget.tag.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tagId,
          style: GoogleFonts.pacifico(color: Colors.black, fontSize: 17.0),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.lightGreen,
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
