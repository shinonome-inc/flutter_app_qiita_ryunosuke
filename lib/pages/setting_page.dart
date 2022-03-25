import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/appbar_design.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDesign(text: 'Settings'),
      body: Container(),
    );
  }
}
