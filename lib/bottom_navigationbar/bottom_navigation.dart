import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/pages/feed_page.dart';
import 'package:flutter_app_qiita/pages/user_page/my_page.dart';
import 'package:flutter_app_qiita/pages/tag_page.dart';
import 'package:flutter_app_qiita/service/qiita_client.dart';

import '../pages/setting_page/setting_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  bool accessTokenIsSaved = false;

  void confAccessTokenIsSaved() async {
    accessTokenIsSaved = await QiitaClient.accessTokenIsSaved();
    setState(() {});
  }

  @override
  void initState() {
    confAccessTokenIsSaved();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: Colors.lightGreen,
        inactiveColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted_outlined),
            label: 'フィード',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.label_outline),
            label: 'タグ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'マイページ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: '設定',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) => const CupertinoPageScaffold(
                child: FeedPage(),
              ),
            );
          case 1:
            return CupertinoTabView(
              builder: (context) => const CupertinoPageScaffold(
                child: TagPage(),
              ),
            );
          case 2:
            return CupertinoTabView(
              builder: (context) =>  CupertinoPageScaffold(
                child: Mypage(accessTokenIsSaved: accessTokenIsSaved,),
              ),
            );
          case 3:
            return CupertinoTabView(
              builder: (context) => const CupertinoPageScaffold(
                child: SettingPage(),
              ),
            );
          default:
            return Container();
        }
      },
    );
  }
}
