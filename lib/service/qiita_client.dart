import 'dart:convert';
import 'package:flutter_app_qiita/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/article.dart';
import '../models/tag.dart';

class QiitaClient {
  static final clientID = dotenv.env['CLIENTID'];
  static final clientSecret = dotenv.env['CLIENTSECRET'];
  static const keyAccessToken = 'qiita/accessToken';

  static String createAuthorizeUrl() {
    const scope = 'read_qiita%20write_qiita';
    String url =
        'https://qiita.com/api/v2/oauth/authorize?client_id=$clientID&scope=$scope';
    return url;
  }

  static Future<String> createAccessTokenFromCallbackUri(Uri uri) async {
    final String? code = uri.queryParameters['code']; //アクセストークンと交換用文字列
    final response =
        await http.post(Uri.parse('https://qiita.com/api/v2/access_tokens'),
            headers: {
              'content-type': 'application/json',
            },
            body: jsonEncode({
              'client_id': clientID,
              'client_secret': clientSecret,
              'code': code,
            }));
    if (response.statusCode == 201) {
      final body = jsonDecode(response.body);
      final accessToken = body['token'];

      return accessToken;
    } else {
      throw Exception('Request failed with status:${response.statusCode}');
    }
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

  static Future<void> deleteAccessToken() async {
    final accessToken = await getAccessToken();
    String url = "https://qiita.com/api/v2/access_tokens/$accessToken";
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 204) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(keyAccessToken);
    } else {
      throw Exception('Failed to delete');
    }
  }

  static Future<List<Article>> fetchArticle(
    int page,
    String query,
    String tagId,
  ) async {
    String url;
    String? accessToken = await getAccessToken();
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
        if (accessToken!.isNotEmpty) 'Authorization': 'Bearer $accessToken',
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

  static Future<User> fetchMyProfile() async {
    final accessToken = await getAccessToken();
    var url = 'https://qiita.com/api/v2/authenticated_user';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> userJsonArray = json.decode(response.body);
      var user = User.fromJson(userJsonArray);
      return user;
    } else {
      throw Exception('Failed to load user');
    }
  }

  static Future<List<Article>> fetchMyArticle(int page) async {
    final accessToken = await getAccessToken();
    var url = "https://qiita.com/api/v2/authenticated_user/items?page=$page";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> articleJsonArray = json.decode(response.body);
      return articleJsonArray.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load article');
    }
  }

  static Future<List<User>> fetchFollowees(String userId) async {
    final accessToken = await getAccessToken();
    final url = "https://qiita.com/api/v2/users/$userId/followees";
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $accessToken',
    });
    if (response.statusCode == 200) {
      final List<dynamic> followeesJsonArray = json.decode(response.body);
      return followeesJsonArray.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load followees');
    }
  }

  static Future<List<User>> fetchFollowers(String userId) async {
    final accessToken = await getAccessToken();
    final _url = "https://qiita.com/api/v2/users/$userId/followers";
    final response = await http.get(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> followersJsonArray = json.decode(response.body);
      return followersJsonArray.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load followers');
    }
  }
}
