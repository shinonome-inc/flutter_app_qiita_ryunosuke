import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/appbar_design.dart';
import 'package:flutter_app_qiita/components/user_list_view.dart';
import 'package:flutter_app_qiita/pages/error_page.dart';
import 'package:flutter_app_qiita/service/qiita_client.dart';

import '../../models/user.dart';

class FollowerPage extends StatefulWidget {
  final User user;
  const FollowerPage({Key? key, required this.user}) : super(key: key);

  @override
  State<FollowerPage> createState() => _FollowerPageState();
}

class _FollowerPageState extends State<FollowerPage> {
  late Future<List<User>> futureFollowerList;
  int page = 1;
  @override
  void initState() {
    futureFollowerList = QiitaClient.fetchFollowers(widget.user.id, 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDesign(
        text: 'Followers',
        useBackButton: true,
      ),
      body: FutureBuilder<List<User>>(
        future: futureFollowerList,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return UserListView(users: snapshot.data!);
          } else if (snapshot.hasError) {
            return ErrorPage(onTapReload: () {
              setState(() {
                futureFollowerList =
                    QiitaClient.fetchFollowers(widget.user.id, 1);
              });
            });
          } else if (snapshot.data?.isEmpty == true) {
            return const Center(
              child: Text('フォロワーなし'),
            );
          }
          return const Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Center(
              child: SizedBox(
                  height: 30, width: 30, child: CupertinoActivityIndicator()),
            ),
          );
        },
      ),
    );
  }
}
