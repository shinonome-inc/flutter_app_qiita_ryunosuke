import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/models/article.dart';
import 'package:flutter_app_qiita/pages/article_detail.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

//画像を取り除いたMypageやUserPage用ArticleList
class UserPageArticleList extends StatefulWidget {
  final List<Article> articles;
  final String userId;

  const UserPageArticleList({
    Key? key,
    required this.articles,
    required this.userId,
  }) : super(key: key);

  @override
  State<UserPageArticleList> createState() => _UserPageArticleListState();
}

class _UserPageArticleListState extends State<UserPageArticleList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: widget.articles.length,
      itemBuilder: (context, index) {
        final article = widget.articles[index];
        DateTime dateTime = DateTime.parse(article.createdAt);
        return ListTile(
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
                    '投稿日:' + DateFormat('yyyy/M/d').format(dateTime),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                    strutStyle: const StrutStyle(
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(width: 3.0),
                  Text(
                    'LGTM:' + article.likesCount.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                    strutStyle: const StrutStyle(
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            showCupertinoModalBottomSheet(
              useRootNavigator: true,
              context: context,
              enableDrag: true,
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
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 2.0,
          color: Colors.grey,
          indent: 62.0,
        );
      },
    );
  }
}
