import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/user_page_article_list.dart';
import 'package:flutter_app_qiita/models/article.dart';
import 'package:flutter_app_qiita/service/qiita_client.dart';

import '../../models/user.dart';
import 'follow_page.dart';
import 'follower_page.dart';

//Userのプロフィール表示用クラス
class UserProfilePage extends StatefulWidget {
  final User user;
  const UserProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Future<List<Article>> futureUserArticles;
  late List<Article> userArticles;
  int page = 1;

  Future<void> onRefresh() async {
    var newItems = await QiitaClient.fetchUserArticle(widget.user.id, 1);
    setState(() {
      userArticles.clear();
      userArticles.addAll(newItems);
    });
  }

  Future<void> addItems(int page) async {
    var items = await QiitaClient.fetchUserArticle(widget.user.id, page);
    setState(() {
      userArticles.addAll(items);
    });
  }

  Widget userProfile() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          CachedNetworkImage(
            imageUrl: widget.user.iconUrl,
            imageBuilder: (context, imageProvider) => Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
              ),
            ),
            placeholder: (context, url) => const SizedBox(
                width: 80.0, height: 80.0, child: CupertinoActivityIndicator()),
            errorWidget: (context, url, error) => Container(
              width: 80.0,
              height: 80.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/default_icon_image.png'),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(0, 16, 0, 4),
      ),
      Text(
        widget.user.name!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black, fontSize: 14.0),
      ),
      const SizedBox(height: 4.0),
      Text(
        '@' + widget.user.id,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: const TextStyle(
          color: Color(0xFF828282),
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          widget.user.description!,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF828282),
          ),
        ),
      ),
      Row(
        children: <Widget>[
          TextButton(
            onPressed: () {
              if (widget.user.followingsCount > 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => FollowPage(
                              user: widget.user,
                            ))));
              }
            },
            child: Text(widget.user.followingsCount.toString() + 'フォロー中'),
            style: TextButton.styleFrom(
              primary: Colors.black,
              padding: const EdgeInsets.all(0),
            ),
          ),
          const SizedBox(height: 4.0),
          TextButton(
            onPressed: () {
              if (widget.user.followersCount > 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) =>
                            FollowerPage(user: widget.user))));
              }
            },
            child: Text(widget.user.followersCount.toString() + 'フォロワー'),
            style: TextButton.styleFrom(
              primary: Colors.black,
            ),
          ),
        ],
      ),
    ]);
  }

  @override
  void initState() {
    futureUserArticles = QiitaClient.fetchUserArticle(widget.user.id, 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 24.0, top: 25.0),
          child: userProfile(),
        ),
        Container(
          height: 28,
          width: double.infinity,
          color: const Color(0xFFF2F2F2),
          child: const Padding(
            padding: EdgeInsets.only(top: 7, left: 12),
            child: Text(
              '投稿記事',
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              final metrics = notification.metrics;
              if (metrics.extentAfter == 0) {
                addItems(++page);
              }
              return true;
            },
            child: FutureBuilder<List<Article>>(
              future: futureUserArticles,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Article>> snapshot) {
                if (snapshot.hasData) {
                  userArticles = snapshot.data as List<Article>;
                  return CustomRefreshIndicator(
                    onRefresh: onRefresh,
                    builder: (
                      BuildContext context,
                      Widget child,
                      IndicatorController controller,
                    ) {
                      return AnimatedBuilder(
                        animation: controller,
                        builder: (BuildContext context, _) {
                          return Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              if (!controller.isIdle)
                                Positioned(
                                    top: 50 * controller.value,
                                    child: const CupertinoActivityIndicator()),
                              Transform.translate(
                                offset: Offset(0, 100.0 * controller.value),
                                child: child,
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: UserPageArticleList(
                        articles: userArticles, userId: widget.user.id),
                  );
                } else {
                  return const CupertinoActivityIndicator();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
