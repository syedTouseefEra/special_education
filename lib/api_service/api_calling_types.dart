import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:special_education/api_service/api_service_url.dart';

class ApiCallingTypes {
  final String baseUrl;

  ApiCallingTypes({required this.baseUrl});

  Future<http.Response> getApiCall({
    required String url,
    Map<String, String>? params,
    String? token,
  }) async {
    try {
      if (params != null && params.isNotEmpty) {
        String queryString = Uri(queryParameters: params).query;
        url = '$url?$queryString';
      }

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      _logRequest('GET', url, headers, null, response, params: params);

      return response;
    } catch (e) {
      throw Exception('Failed to make GET request: $e');
    }
  }

  Future<http.Response> postApiCall({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    String? token,
    Map<String, String>? params,
  }) async {
    final defaultHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    try {
      if (params != null && params.isNotEmpty) {
        String queryString = Uri(queryParameters: params).query;
        url = '$url?$queryString';
      }

      final response = await http.post(
        Uri.parse(url),
        headers: defaultHeaders,
        body: json.encode(body),
      );

      _logRequest('POST', url, defaultHeaders, body, response, params: params);

      return response;
    } catch (e) {
      print('❌ Exception during POST: $e');
      throw Exception('POST request failed: $e');
    }
  }

  Future<http.Response> putApiCall({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    String? token,
    Map<String, String>? params,
  }) async {
    final defaultHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    try {
      if (params != null && params.isNotEmpty) {
        String queryString = Uri(queryParameters: params).query;
        url = '$url?$queryString';
      }

      final response = await http.put(
        Uri.parse(url),
        headers: defaultHeaders,
        body: json.encode(body),
      );

      _logRequest('PUT', url, defaultHeaders, body, response, params: params);

      return response;
    } catch (e) {
      print('❌ Exception during PUT: $e');
      throw Exception('PUT request failed: $e');
    }
  }


  Future<String> uploadFile({
    required String filePath,
    required String folderId,
    String? url,
  }) async {
    try {
      final uploadUrl = url ?? ApiServiceUrl.fileUpload;

      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      request.fields.addAll({
        'folderId': folderId,
      });

      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.bytesToString();
      } else {
        return 'Failed to upload: ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }


  void _logRequest(
      String method,
      String url,
      Map<String, String> headers,
      dynamic body,
      http.Response response, {
        Map<String, String>? params,
      }) {
    if (kDebugMode) {
      debugPrint('🟦 [$method] REQUEST');
      debugPrint('➡️ URL: $url');
      debugPrint('📬 Headers: ${jsonEncode(headers)}');
      if (params != null) debugPrint('🔍 Params: ${jsonEncode(params)}');
      if (body != null) debugPrint('📦 Body: ${jsonEncode(body)}');
      debugPrint('✅ Response Code: ${response.statusCode}');
      printLongString('📝 Response Body: ${response.body}');
    }
  }

  // Helper method to safely print long strings
  void printLongString(String text) {
    const int chunkSize = 800;
    for (var i = 0; i < text.length; i += chunkSize) {
      debugPrint(
        text.substring(i, i + chunkSize > text.length ? text.length : i + chunkSize),
      );
    }
  }
}
