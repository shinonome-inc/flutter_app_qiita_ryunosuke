import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/appbar_design.dart';
import 'package:flutter_app_qiita/pages/user_page/follow_page.dart';

import '../../../models/user.dart';
import '../../../service/qiita_client.dart';
import '../../components/article_list_view.dart';
import '../../models/article.dart';
import '../error_page.dart';
import 'follower_page.dart';

class UserPage extends StatefulWidget {
  final User user;
  const UserPage({Key? key, required this.user}) : super(key: key);
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Future<User>? userProfile;
  bool accessTokenIsSaved = false;

  int page = 1;

  void reload() {
    userProfile = QiitaClient.fetchUserProfile(widget.user.id);
  }

  Future<void> onRefreshUser() async {
    userProfile = QiitaClient.fetchUserProfile(widget.user.id);
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
          text: 'Users',
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
      return const Center(
        child: Text('データなし'),
      );
    }
  }
}

//user_pageのプロフィール表示用クラス
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
    futureUserArticles = QiitaClient.fetchUserArticle(widget.user.id, page);
  }

  Future<void> addItems(int page) async {
    var items = await QiitaClient.fetchUserArticle(widget.user.id, page);
    setState(() {
      userArticles.addAll(items);
    });
  }

  @override
  void initState() {
    futureUserArticles = QiitaClient.fetchUserArticle(widget.user.id, page);
    super.initState();
  }

  Widget myProfile() {
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => FollowPage(
                            user: widget.user,
                          ))));
            },
            child: Text(widget.user.followingsCount.toString() + 'フォロー中'),
            style: TextButton.styleFrom(
              primary: Colors.black,
            ),
          ),
          const SizedBox(height: 4.0),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => FollowerPage(user: widget.user))));
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 24.0, top: 25.0),
          child: myProfile(),
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
        NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            final metrics = notification.metrics;
            if (metrics.extentAfter == 0) {
              addItems(++page);
            }
            return true;
          },
          child: FutureBuilder<List<Article>>(
            future: futureUserArticles,
            builder:
                (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
              if (snapshot.hasData) {
                return RefreshIndicator(
                  onRefresh: onRefresh,
                  child: (() {
                    if (snapshot.data?.isEmpty ?? true) {
                      return const Center(child: Text("まだ投稿がありません"));
                    } else {
                      return ArticleListView(
                        articles: snapshot.data!,
                      );
                    }
                  })(),
                );
              } else if (snapshot.hasError) {
                return ErrorPage(onTapReload: () {
                  futureUserArticles =
                      QiitaClient.fetchUserArticle(widget.user.id, page);
                });
              } else {
                return const CupertinoActivityIndicator();
              }
            },
          ),
        ),
      ],
    );
  }
}
