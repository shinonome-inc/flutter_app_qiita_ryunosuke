import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/appbar_design.dart';


class TagPage extends StatefulWidget {
  const TagPage({Key? key}) : super(key: key);

  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDesign(text: 'Tag',),
      body: Container(),
    );
  }
}
