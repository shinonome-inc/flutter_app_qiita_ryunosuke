import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/appbar_design.dart';
import 'package:flutter_app_qiita/components/article_list_view.dart';
import 'package:flutter_app_qiita/service/qiita_client.dart';

import '../models/article.dart';
import 'error_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late Future<List<Article>> futureArticles;
  List<Article> articles = [];
  String searchWord = '';
  var textController = TextEditingController();
  int page = 1;

  Widget textField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 36.0,
      width: double.infinity,
      child: TextFormField(
        autocorrect: true,
        controller: textController,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            labelText: 'Search',
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.white),
            )),
        onChanged: (value) {
          setState(() {
            searchWord = value;
            reloadArticle();
          });
        },
      ),
    );
  }

  PreferredSize? feedAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: Center(
        child: Column(
          children: [
            AppBarDesign(text: 'Feed'),
            textField(),
          ],
        ),
      ),
    );
  }

  void reloadArticle() {
    setState(() {
      futureArticles = QiitaClient.fetchArticle(page, searchWord);
    });
  }

  @override
  void initState() {
    futureArticles = QiitaClient.fetchArticle(page, searchWord);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: feedAppBar(),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<List>(
          future: futureArticles,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              articles = snapshot.data as List<Article>;
              return Column(
                children: [
                  const Divider(color: Colors.black),
                  ArticleListView(articles: articles),
                ],
              );
            } else if (snapshot.hasError) {
              return ErrorPage(
                onTapReload: () {
                  reloadArticle();
                },
              );
            } else if (searchWord.isNotEmpty) {
              return searchError();
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

Widget searchError() {
  return SafeArea(
    child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              '検索にマッチする記事が見つかりませんでした',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '検索条件を変えるなどして再度検索をしてください',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
