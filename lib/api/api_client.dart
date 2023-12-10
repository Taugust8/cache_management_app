import 'dart:convert';
import 'package:http/http.dart';

class ApiClient {
  factory ApiClient() => _instance;
  ApiClient._internal();
  static final ApiClient _instance = ApiClient._internal();
  static ApiClient get instance => _instance;
  final String _baseUrl = 'http://localhost/api';

  Uri getEndpoint({Type? entityType, String? id, String? suffix}) {
    String endpoint = '';
    if (entityType is Type) {
      endpoint += '/${entityType.toString().toLowerCase()}s';
    }
    if (id is String) {
      endpoint += '/$id';
    }
    if (suffix is String) {
      endpoint += '/$suffix';
    }
    return Uri.parse('$_baseUrl$endpoint');
  }

  Future<Map<String, dynamic>> fetchAllEntity(
    Type entityType, {
    String? endpointSuffix,
    bool token = true,
  }) async {
    Uri endpoint = getEndpoint(entityType: entityType, suffix: endpointSuffix);
    final Response response = await get(
      endpoint,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception(response);
    }
  }

  Future<Map<String, dynamic>> customPost(
    String customEndpoint, {
    Map<String, String> body = const <String, String>{},
    int statusCode = 201,
    bool token = true,
  }) async {
    Uri endpoint = getEndpoint(suffix: customEndpoint);
    final Response response = await post(
      endpoint,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == statusCode) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception(response);
    }
  }
}
