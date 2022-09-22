import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/appbar_design.dart';
import 'package:flutter_app_qiita/components/setting_page_item_component.dart';
import 'package:flutter_app_qiita/pages/setting_page/privacy_policy.dart';
import 'package:flutter_app_qiita/pages/setting_page/terms_of_service.dart';
import 'package:flutter_app_qiita/pages/top_page.dart';
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
            height: 32.0,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 8),
            child: Text(
              'アプリ情報',
              style: TextStyle(color: Color(0xFF828282), fontSize: 12.0),
            ),
          ),
          SettingPageItemComponent(
            text: 'プライバシーポリシー',
            item: const Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.grey,
            ),
            onTap: () {
              showModalBottomSheet(
                  useRootNavigator: true,
                  enableDrag: true,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10.0),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.95,
                        child: const PrivacyPolicy());
                  });
            },
          ),
          SettingPageItemComponent(
            text: '利用規約',
            item: const Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.grey,
            ),
            onTap: () {
              showModalBottomSheet(
                  useRootNavigator: true,
                  enableDrag: true,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10.0),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.95,
                        child: const TermsOfService());
                  });
            },
          ),
          SettingPageItemComponent(
            text: 'アプリバージョン',
            item: Text(
              'v' + _packageInfo.version,
              style: const TextStyle(fontSize: 14.0, color: Colors.black),
            ),
            onTap: () {},
          ),
          const SizedBox(
            height: 36.0,
          ),
          if (accessTokenIsSaved)
            const Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 8),
              child: Text(
                'その他',
                style: TextStyle(color: Color(0xFF828282), fontSize: 12.0),
              ),
            ),
          if (accessTokenIsSaved)
            SettingPageItemComponent(
              text: 'ログアウトする',
              item: Container(),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                          title: const Text('ログアウトしますか'),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text('はい'),
                              onPressed: () {
                                QiitaClient.deleteAccessToken();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const TopPage(
                                              uri: null,
                                            )),
                                    (_) => false);
                              },
                            ),
                            CupertinoDialogAction(
                              child: const Text('いいえ'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ));
              },
            )
        ],
      ),
    );
  }
}
