import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/appbar_design.dart';
import 'package:flutter_app_qiita/pages/not_login_page.dart';
import 'package:flutter_app_qiita/pages/user_page/user_profile_page.dart';

import '../../../models/user.dart';
import '../../../service/qiita_client.dart';

import '../error_page.dart';

class Mypage extends StatefulWidget {
  final bool accessTokenIsSaved;
  const Mypage({Key? key, required this.accessTokenIsSaved}) : super(key: key);
  @override
  _MypageState createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  Future<User>? myProfile;
  late User? user;

  int page = 1;

  void reloadMyProfile() {
    setState(() {
      myProfile = QiitaClient.fetchMyProfile();
    });
  }

  Future<void> onRefreshUser() async {
    setState(() {
      myProfile = QiitaClient.fetchMyProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (widget.accessTokenIsSaved) {
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
                        return UserProfilePage(user: snapshot.data!);
                      } else if (snapshot.hasError) {
                        return ErrorPage(
                          onTapReload: () {
                            reloadMyProfile();
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
    } else if (widget.accessTokenIsSaved == false) {
      return const NotLoginPage();
    } else {
      return Container();
    }
  }
}
