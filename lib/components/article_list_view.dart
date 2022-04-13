import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/article.dart';

class ArticleListView extends StatefulWidget {
  final List<Article> articles;

  const ArticleListView({Key? key, required this.articles}) : super(key: key);

  @override
  State<ArticleListView> createState() => _ArticleListViewState();
}

class _ArticleListViewState extends State<ArticleListView> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
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
              placeholder: (context, url) => const CupertinoActivityIndicator(),
              errorWidget: (context, url, error) => const Image(
                image: AssetImage('images/default_icon_image'),
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
            subtitle: Column(
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
                      '投稿日:' + DateFormat('yyyy/M/d').format(dateTime),
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
          );
        },
      ),
    );
  }
}