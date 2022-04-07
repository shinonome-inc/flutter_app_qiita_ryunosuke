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
  List<Article> articles = [];

  bool isNetworkError = false;

  Widget textField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 36.0,
      width: double.infinity,
      child: TextFormField(
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            labelText: 'Search',
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.white),
            )),
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

  Future<void> initArticle() async {
    articles = await QiitaClient.fetchArticle();
  }

  Future<void> reloadArticle() async {
    initArticle();
    setState(() {
      ArticleListView(articles: articles);
    });
  }

  @override
  void initState() {
    initArticle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: feedAppBar(),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<List>(
          future: QiitaClient.fetchArticle(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
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
            } else {
              return const Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Center(
                  child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CupertinoActivityIndicator()),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
