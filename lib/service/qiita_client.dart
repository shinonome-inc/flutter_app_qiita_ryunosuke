import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/article.dart';
import '../models/tag.dart';

//Qiita api 記事取得
class QiitaClient {
  static Future<List<Article>> fetchArticle(
    int page,
    String query,
    String tagId,
  ) async {
    String url;
    if (query.isNotEmpty) {
      url = 'https://qiita.com/api/v2/items?page=$page&per_page=20&query=' +
          query +
          '%3AQiita';
    } else if (tagId.isNotEmpty) {
      url = 'https://qiita.com/api/v2/tags/$tagId/items?page=$page';
    } else {
      url = 'https://qiita.com/api/v2/items?page=$page';
    }
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'content-type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  static Future<List<Tag>> fetchTag(int page) async {
    var url = 'https://qiita.com/api/v2/tags?page=$page&per_page=20&sort=count';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'content-type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> tagJsonArray = json.decode(response.body);
      return tagJsonArray.map((json) => Tag.fromJson(json)).toList();
    } else {
      throw Exception('faild to load tags');
    }
  }
}
