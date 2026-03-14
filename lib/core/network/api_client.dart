import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiResponse {
  final dynamic data;
  final int statusCode;

  ApiResponse({required this.data, required this.statusCode});
}

class ApiClient {
  final String _baseUrl = 'https://appskilltest.zybotech.in';
  final http.Client _client = http.Client();

  ApiClient();

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<ApiResponse> post(String path, {dynamic data}) async {
    try {
      final url = Uri.parse('$_baseUrl$path');
      final headers = await _getHeaders();
      final response = await _client.post(
        url,
        headers: headers,
        body: data != null ? jsonEncode(data) : null,
      );
      return ApiResponse(
        data: jsonDecode(response.body),
        statusCode: response.statusCode,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      var uri = Uri.parse('$_baseUrl$path');
      if (queryParameters != null) {
        uri = uri.replace(queryParameters: queryParameters.map((key, value) => MapEntry(key, value.toString())));
      }
      final headers = await _getHeaders();
      final response = await _client.get(uri, headers: headers);
      return ApiResponse(
        data: jsonDecode(response.body),
        statusCode: response.statusCode,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> delete(String path, {dynamic data}) async {
    try {
      final url = Uri.parse('$_baseUrl$path');
      final headers = await _getHeaders();
      final response = await _client.delete(
        url,
        headers: headers,
        body: data != null ? jsonEncode(data) : null,
      );
      return ApiResponse(
        data: jsonDecode(response.body),
        statusCode: response.statusCode,
      );
    } catch (e) {
      rethrow;
    }
  }
}
