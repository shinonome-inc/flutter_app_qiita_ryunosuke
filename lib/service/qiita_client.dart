import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/article.dart';
import '../models/tag.dart';



//Qiita api 記事取得
class QiitaClient {
  static final clientID = dotenv.env['CLIENTID'];
  static final clientSecret = dotenv.env['CLIENTSECRET'];
  static const keyAccessToken = 'qiita/accessToken';
  
  static String createdAuthorizeUrl() {
    const scope = 'read_qiita%20write_qiita';
    String _url =
        'https://qiita.com/api/v2/oauth/authorize?client_id=$clientID&scope=$scope';
    return _url;
  }

static Future<String> createAccessTokenFromCallbackUri(
      Uri uri, ) async {
    final String? code = uri.queryParameters['code'];

    final response = await http.post(
      Uri.parse('https://qiita.com/api/v2/access_tokens'),
      headers: {
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'client_id': clientID,
        'client_secret': clientSecret,
        'code': code,
      }),
    );
    final body = jsonDecode(response.body);
    final accessToken = body['token'];

    return accessToken;
  }

  static Future<void> saveAccessToken(String accessToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyAccessToken, accessToken);
  }

  static Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyAccessToken);
  }

  static Future<bool> accessTokenIsSaved() async {
    final accessToken = await getAccessToken();
    return accessToken != null;
  }

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
