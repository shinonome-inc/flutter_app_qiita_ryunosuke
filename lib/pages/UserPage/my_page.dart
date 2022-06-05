import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/appbar_design.dart';
import 'package:flutter_app_qiita/pages/UserPage/my_profile_page.dart';
import 'package:flutter_app_qiita/pages/not_login_page.dart';

import '../../../models/user.dart';
import '../../../service/qiita_client.dart';
import '../error_page.dart';

class Mypage extends StatefulWidget {
  const Mypage({
    Key? key,
  }) : super(key: key);
  @override
  _MypageState createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  Future<User>? myProfile;
  bool accessTokenIsSaved = false;
  bool hasSnapshot = false;
  late User? user;

  int page = 1;

  Widget notLoginView() => const NotLoginPage();

  void reload() {
    myProfile = QiitaClient.fetchMyProfile();
  }

  Future<void> onRefreshUser() async {
    myProfile = QiitaClient.fetchMyProfile();
  }

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
    Size size = MediaQuery.of(context).size;
    if (accessTokenIsSaved) {
      myProfile = QiitaClient.fetchMyProfile();
      return Scaffold(
        appBar: AppBarDesign(text: 'MyPage'),
        body: Column(
          children: [
            Flexible(
              child: SizedBox(
                height: size.height,
                width: size.width,
                child: RefreshIndicator(
                  edgeOffset: -500,
                  onRefresh: onRefreshUser,
                  child: FutureBuilder<User>(
                    future: myProfile,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return MyProfilePage(user: snapshot.data!);
                      } else if (snapshot.hasError) {
                        return ErrorPage(
                          onTapReload: () {
                            reload();
                          },
                        );
                      }
                      return const Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Center(
                          child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CupertinoActivityIndicator()),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return notLoginView();
    }
  }
}
