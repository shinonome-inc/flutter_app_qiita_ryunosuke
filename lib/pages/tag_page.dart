import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_qiita/components/appbar_design.dart';
import 'package:flutter_app_qiita/models/tag.dart';
import 'package:flutter_app_qiita/pages/tag_list_view.dart';
import 'package:flutter_app_qiita/service/qiita_client.dart';

import 'error_page.dart';

class TagPage extends StatefulWidget {
  const TagPage({Key? key}) : super(key: key);

  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  late Future<List<dynamic>> futureTag;
  List<Tag> tags = [];

  @override
  void initState() {
    futureTag = QiitaClient.fetchTag();
    super.initState();
  }

  void reloadTag() {
    setState(() {
      futureTag = QiitaClient.fetchTag();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDesign(
        text: 'Tag',
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureTag,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          int tagsNum = (MediaQuery.of(context).size.width ~/ 162);      
          if (snapshot.hasData) {
            tags = snapshot.data;
            return TagListView(
              tags: tags,
              tagsNum: tagsNum,
            );
          } else if (snapshot.hasError) {
            return ErrorPage(onTapReload: reloadTag);
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
    );
  }
}
