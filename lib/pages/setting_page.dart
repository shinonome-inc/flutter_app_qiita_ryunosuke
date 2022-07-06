import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/appbar_design.dart';
import 'package:flutter_app_qiita/components/setting_page_item_component.dart';
import 'package:flutter_app_qiita/service/qiita_client.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool accessTokenIsSaved = false;
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
    buildSignature: '',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  void confAccessTokenIsSaved() async {
    accessTokenIsSaved = await QiitaClient.accessTokenIsSaved();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    confAccessTokenIsSaved();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDesign(text: 'Settings'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 31.5,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              'アプリ情報',
              style: TextStyle(color: Color(0xFF828282), fontSize: 12.0),
            ),
          ),
          const SettingPageItemComponent(
            text: 'プライバシーポリシー',
            item: Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.grey,
            ),
          ),
          const SettingPageItemComponent(
            text: '利用規約',
            item: Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.grey,
            ),
          ),
          SettingPageItemComponent(
            text: 'アプリバージョン',
            item: Text(
              'v' + _packageInfo.version,
              style: const TextStyle(fontSize: 14.0, color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 38.0,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              'その他',
              style: TextStyle(color: Color(0xFF828282), fontSize: 12.0),
            ),
          ),
          if (accessTokenIsSaved)
            SettingPageItemComponent(
              text: 'ログアウトする',
              item: Container(),
            )
        ],
      ),
    );
  }
}
