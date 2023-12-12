import 'dart:convert';
import 'package:http/http.dart';

class ApiClient {
  factory ApiClient() => _instance;
  ApiClient._internal();
  static final ApiClient _instance = ApiClient._internal();
  static ApiClient get instance => _instance;

  Future<dynamic> getData(String url) async {
    final Response response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      return data;
    } else {
      throw Exception(response);
    }
  }
}
