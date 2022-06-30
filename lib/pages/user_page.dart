import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/appbar_design.dart';
import 'package:flutter_app_qiita/pages/not_login_page.dart';
import 'package:flutter_app_qiita/service/qiita_client.dart';

import '../models/user.dart';
import 'error_page.dart';
import 'user_profile_page.dart';

class UserPage extends StatefulWidget {
  final User user;

  const UserPage({Key? key, required this.user}) : super(key: key);
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Future<User>? userProfile;
  bool accessTokenIsSaved = false;
  late User? user;

  int page = 1;

  void reloadUserProfile() {
    setState(() {
      userProfile = QiitaClient.fetchUserProfile(widget.user.id);
    });
  }

  Future<void> onRefreshUser() async {
    setState(() {
      userProfile = QiitaClient.fetchUserProfile(widget.user.id);
    });
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
      userProfile = QiitaClient.fetchUserProfile(widget.user.id);
      return Scaffold(
        appBar: AppBarDesign(
          text: 'User',
          useBackButton: true,
        ),
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
                    future: userProfile,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return UserProfilePage(user: snapshot.data!);
                      } else if (snapshot.hasError) {
                        return ErrorPage(
                          onTapReload: () {
                            reloadUserProfile();
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
      return const NotLoginPage();
    }
  }
}
