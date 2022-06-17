import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/appbar_design.dart';
import 'package:flutter_app_qiita/pages/error_page.dart';
import 'package:flutter_app_qiita/service/qiita_client.dart';

import '../../components/user_list_view.dart';
import '../../models/user.dart';

class FollowPage extends StatefulWidget {
  final User user;

  const FollowPage({Key? key, required this.user}) : super(key: key);

  @override
  State<FollowPage> createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {
  late Future<List<User>> futureFolloweesList;

  @override
  void initState() {
    futureFolloweesList = QiitaClient.fetchFollowees(widget.user.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDesign(
        text: 'Follows',
        useBackButton: true,
      ),
      body: FutureBuilder<List<User>>(
        future: futureFolloweesList,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return UserListView(
              users: snapshot.data!,
            );
          } else if (snapshot.hasError) {
            return ErrorPage(onTapReload: () {
              futureFolloweesList = QiitaClient.fetchFollowees(widget.user.id);
            });
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
