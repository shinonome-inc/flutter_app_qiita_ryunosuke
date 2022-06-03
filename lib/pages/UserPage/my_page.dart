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
  bool accecssTokenIsSaved = false;
  bool hasSnapshot = false;
  late User? user;

  int page = 1;

  Widget notLoginView() => const NotLoginPage();

  void reload() {
    myProfile = QiitaClient.fetchMyprofile();
  }

  Future<void> onRefreshUser() async {
    myProfile = QiitaClient.fetchMyprofile();
  }

  void confAcessTokenIsSaved() async {
    accecssTokenIsSaved = await QiitaClient.accessTokenIsSaved();
  }

  @override
  void initState() {
    confAcessTokenIsSaved();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (accecssTokenIsSaved) {
      myProfile = QiitaClient.fetchMyprofile();
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
