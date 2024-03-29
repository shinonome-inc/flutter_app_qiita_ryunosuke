import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/appbar_design.dart';
import 'package:flutter_app_qiita/components/article_list_view.dart';
import 'package:flutter_app_qiita/models/article.dart';
import 'package:flutter_app_qiita/pages/error_page.dart';
import 'package:flutter_app_qiita/service/qiita_client.dart';

import '../models/tag.dart';

class TagDetail extends StatefulWidget {
  final Tag tag;
  const TagDetail({Key? key, required this.tag}) : super(key: key);

  @override
  State<TagDetail> createState() => _TagDetailState();
}

class _TagDetailState extends State<TagDetail> {
  String tagId = '';
  late Future<List<Article>> futureArticles;
  late List<Article> articles;
  int page = 1;

  void reload() {
    page = 1;
    articles.clear();
    setState(() {
      futureArticles = QiitaClient.fetchArticle(page, '', tagId);
    });
  }

  Future<void> addTagDetailItems(int page) async {
    var tagDetailItems = await QiitaClient.fetchArticle(page, '', tagId);
    setState(() {
      articles.addAll(tagDetailItems);
    });
  }

  Future<void> onRefreshTagDetail() async {
    var newItems = await QiitaClient.fetchArticle(1, '', tagId);
    setState(() {
      articles.clear();
      articles.addAll(newItems);
    });
  }

  @override
  void initState() {
    tagId = widget.tag.id;
    futureArticles = QiitaClient.fetchArticle(page, '', tagId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDesign(
        text: tagId,
        useBackButton: true,
      ),
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          final metrics = notification.metrics;
          if (metrics.extentAfter == 0) {
            addTagDetailItems(++page);
          }
          return true;
        },
        child: FutureBuilder<List<dynamic>>(
          future: futureArticles,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              articles = snapshot.data as List<Article>;
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
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
                      child: CustomRefreshIndicator(
                        builder: (context, child, controller) =>
                            AnimatedBuilder(
                          animation: controller,
                          builder: (BuildContext context, _) {
                            return Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                if (!controller.isIdle)
                                  Positioned(
                                      top: 50 * controller.value,
                                      child:
                                          const CupertinoActivityIndicator()),
                                Transform.translate(
                                  offset: Offset(0, 100.0 * controller.value),
                                  child: child,
                                ),
                              ],
                            );
                          },
                        ),
                        child: ArticleListView(articles: articles),
                        onRefresh: onRefreshTagDetail,
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              ErrorPage(
                onTapReload: reload,
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
      ),
    );
  }
}
