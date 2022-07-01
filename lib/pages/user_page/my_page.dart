import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/appbar_design.dart';
import 'package:flutter_app_qiita/components/user_page_article_list.dart';
import 'package:flutter_app_qiita/pages/not_login_page.dart';
import 'package:flutter_app_qiita/pages/user_page/follow_page.dart';

import '../../../models/user.dart';
import '../../../service/qiita_client.dart';

import '../../models/article.dart';
import '../error_page.dart';
import 'follower_page.dart';

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
    } else {
      return const NotLoginPage();
    }
  }
}

//my_pageのプロフィール表示用クラス
class MyProfilePage extends StatefulWidget {
  final User user;
  const MyProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late Future<List<Article>> futureMyArticles;
  late List<Article> myArticles;
  int page = 1;

  Future<void> onRefresh() async {
    var newItems = await QiitaClient.fetchMyArticle(1);
    setState(() {
      myArticles.clear();
      myArticles.addAll(newItems);
    });
  }

  Future<void> addItems(int page) async {
    var items = await QiitaClient.fetchMyArticle(page);
    setState(() {
      myArticles.addAll(items);
    });
  }

  @override
  void initState() {
    futureMyArticles = QiitaClient.fetchMyArticle(page);
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
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 24.0, top: 25.0),
            child: myProfile(),
          ),
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
            future: futureMyArticles,
            builder:
                (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
              if (snapshot.hasData) {
                myArticles = snapshot.data!;
                return RefreshIndicator(
                  edgeOffset: -500,
                  onRefresh: onRefresh,
                  child: UserPageArticleList(
                      articles: myArticles, userId: widget.user.id),
                );
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
