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
  late Future<List<User>>? futureFolloweesList;
  late List<User> followeesList;
  int page = 1;

  Future<void> onRefresh() async {
    futureFolloweesList = QiitaClient.fetchFollowees(widget.user.id, 1);
  }

  Future<void> addItems(int page) async {
    var newItems = await QiitaClient.fetchFollowees(widget.user.id, page);
    setState(() {
      followeesList.addAll(newItems);
    });
  }

  @override
  void initState() {
    futureFolloweesList = QiitaClient.fetchFollowees(
      widget.user.id,
      1,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDesign(
        text: 'Follows',
        useBackButton: true,
      ),
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          final metrics = notification.metrics;
          if (metrics.extentAfter == 0) {
            addItems(++page);
          }
          return true;
        },
        child: RefreshIndicator(
          edgeOffset: -500,
          onRefresh: onRefresh,
          child: FutureBuilder<List<User>>(
            future: futureFolloweesList,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                followeesList = snapshot.data as List<User>;
                return UserListView(users: followeesList);
              } else if (snapshot.hasError) {
                return ErrorPage(onTapReload: () {
                  setState(() {
                    futureFolloweesList =
                        QiitaClient.fetchFollowees(widget.user.id, 1);
                  });
                });
              } else if (snapshot.data?.isEmpty == true) {
                return const Center(
                  child: Text('フォローなし'),
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
    );
  }
}
