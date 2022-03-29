import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/appbar_design.dart';

class Mypage extends StatefulWidget {
  const Mypage({ Key? key }): super(key: key);
  @override
  _MypageState createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBarDesign(text:'MyPage',),
        body: Container(),
      );
  }
}
