import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/article_list_view.dart';

import 'package:flutter_app_qiita/models/article.dart';

import '../../../models/user.dart';
import '../../../service/qiita_client.dart';
import '../error_page.dart';


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
    futureMyArticles = QiitaClient.fetchMyArticle(page);
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 24.0, top: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Column(
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
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 16, 0, 4),
                    ),
                    Text(
                      widget.user.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 14.0),
                    ),
                  ],
                ),
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
                  widget.user.description,
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
                    onPressed: () {},
                    child:
                        Text(widget.user.followeesCount.toString() + 'フォロー中'),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  TextButton(
                    onPressed: () {},
                    child:
                        Text(widget.user.followersCount.toString() + 'フォロワー'),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
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
                  futureMyArticles = QiitaClient.fetchMyArticle(page);
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
