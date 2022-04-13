import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/article.dart';

//Qiita api 記事取得
class QiitaClient {
  static Future<List<Article>> fetchArticle() async {
    const url = 'https://qiita.com/api/v2/items';
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
      throw Exception('Failed to load article');
    }
  }
}
