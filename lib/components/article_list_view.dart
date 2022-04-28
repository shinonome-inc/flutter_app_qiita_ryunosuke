import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/service/qiita_client.dart';
import 'package:intl/intl.dart';

import '../models/article.dart';
import '../pages/article_detail.dart';

class ArticleListView extends StatefulWidget {
  final List<Article> articles;

  const ArticleListView({
    Key? key,
    required this.articles,
  }) : super(key: key);

  @override
  State<ArticleListView> createState() => _ArticleListViewState();
}

class _ArticleListViewState extends State<ArticleListView> {
  int page = 2;
  
  Future<void> addItems(int page) async {
    var items = await QiitaClient.fetchArticle(page, '');
    setState(() {
      widget.articles.addAll(items);
    });
  }

  Future<void> onRefresh() async {
    var newItems = await QiitaClient.fetchArticle(1, '');
    setState(() {
      widget.articles.clear();
      widget.articles.addAll(newItems);
    });
  }

  @override
  void initState() {
    super.initState();
    addItems(page++);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        final metrics = notification.metrics;
        if (metrics.extentAfter == 0) {
          addItems(page++);
        }
        return true;
      },
      child: Expanded(
        child: RefreshIndicator(
          edgeOffset: -500, //android likeなindicatorを隠す
          onRefresh: onRefresh,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.articles.length,
            itemBuilder: (context, index) {
              final article = widget.articles[index];
              DateTime dateTime = DateTime.parse(article.createdAt);
              return ListTile(
                leading: CachedNetworkImage(
                  imageUrl: article.user.iconUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 38.0,
                    height: 38.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  placeholder: (context, url) =>
                      const CupertinoActivityIndicator(),
                  errorWidget: (context, url, error) => Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/default_icon_image.png'),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                title: Text(
                  article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                subtitle: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '@' + article.user.id,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 3.0),
                          Text(
                            '投稿日:' +
                                DateFormat('yyyy/M/d').format(dateTime),
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 3.0),
                          Text(
                            'LGTM:' + article.likesCount.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 5.0,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    enableDrag: true,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10.0),
                      ),
                    ),
                    builder: (context) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.95,
                        child: ArticleDetail(
                          article: article,
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
