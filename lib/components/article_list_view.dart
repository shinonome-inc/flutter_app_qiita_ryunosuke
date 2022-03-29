import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/article.dart';

class ArticleListView extends StatelessWidget {
  final List<Article> articles;
  const ArticleListView({Key? key, required this.articles}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LimitedBox(
          maxHeight: 600,
          child: ListView.builder(
            itemCount: articles.length,
            itemBuilder: (BuildContext context, int index) {
              final article = articles[index];
              final likesCount = article.likesCount;
              DateTime dateTime = DateTime.parse(article.createdAt);
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(article.user.iconUrl),
                ),
                title: Text(
                  article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                subtitle: Row(
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
                      'LGTM:' + likesCount.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
