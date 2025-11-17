import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/screen/login/login_view.dart';
import 'package:special_education/utils/exception_handle.dart';
import 'package:special_education/utils/navigation_utils.dart';

class ApiCallingTypes {
  final String baseUrl;

  ApiCallingTypes({required this.baseUrl});

  // Future<http.Response> getApiCall({
  //   required String url,
  //   Map<String, String>? params,
  //   String? token,
  // }) async {
  //   try {
  //     if (params != null && params.isNotEmpty) {
  //       String queryString = Uri(queryParameters: params).query;
  //       url = '$url?$queryString';
  //     }
  //
  //     Map<String, String> headers = {
  //       'Content-Type': 'application/json',
  //     };
  //
  //     if (token != null && token.isNotEmpty) {
  //       headers['Authorization'] = 'Bearer $token';
  //     }
  //
  //     final response = await http.get(
  //       Uri.parse(url),
  //       headers: headers,
  //     );
  //
  //     _logRequest('GET', url, headers, null, response, params: params);
  //
  //     return response;
  //   } catch (e) {
  //     throw Exception('Failed to make GET request: $e');
  //   }
  // }

  // Future<dynamic> getApiCall({
  //   required String url,
  //   Map<String, String>? params,
  //   String? token,
  // }) async {
  //   try {
  //
  //     if (params != null && params.isNotEmpty) {
  //       String queryString = Uri(queryParameters: params).query;
  //       url = '$url?$queryString';
  //     }
  //
  //     Map<String, String> headers = {
  //       'Content-Type': 'application/json',
  //     };
  //
  //     if (token != null && token.isNotEmpty) {
  //       headers['Authorization'] = 'Bearer $token';
  //     }
  //
  //     final response = await http.get(
  //       Uri.parse(url),
  //       headers: headers,
  //     );
  //
  //     _logRequest('GET', url, headers, null, response, params: params);
  //     if (response.statusCode >= 200 && response.statusCode < 300) {
  //       return jsonDecode(response.body);
  //     } else {
  //       final decodedError = jsonDecode(response.body);
  //       throw Exception(decodedError['responseMessage'] ??
  //           'API request failed with status ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to make GET request: $e');
  //   }
  // }


  Future<dynamic> getApiCall({
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

      if (response.statusCode == 401) {
        throw UnauthorizedException("Session expired or unauthorized.");
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return _safeDecode(response.body);
      }

      final errorBody = _safeDecode(response.body);
      throw Exception(
        errorBody['responseMessage'] ??
            "API request failed with status ${response.statusCode}",
      );
    } catch (e) {
      rethrow;
    }
  }

  dynamic _safeDecode(String body) {
    try {
      if (body.isEmpty) return {};
      return jsonDecode(body);
    } catch (_) {
      return {};
    }
  }



  // Future<http.Response> postApiCall({
  //   required String url,
  //   required Map<String, dynamic> body,
  //   Map<String, String>? headers,
  //   String? token,
  //   Map<String, String>? params,
  // }) async {
  //   final defaultHeaders = {
  //     'Content-Type': 'application/json',
  //     if (token != null) 'Authorization': 'Bearer $token',
  //     ...?headers,
  //   };
  //
  //   try {
  //     if (params != null && params.isNotEmpty) {
  //       String queryString = Uri(queryParameters: params).query;
  //       url = '$url?$queryString';
  //     }
  //
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: defaultHeaders,
  //       body: json.encode(body),
  //     );
  //
  //     _logRequest('POST', url, defaultHeaders, body, response, params: params);
  //
  //     return response;
  //   } catch (e) {
  //     print('❌ Exception during POST: $e');
  //     throw Exception('POST request failed: $e');
  //   }
  // }


  Future<Map<String, dynamic>> postApiCall({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    String? token,
    Map<String, String>? params,
  }) async {
    final defaultHeaders = {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    try {
      // Add query parameters to URL if provided
      if (params != null && params.isNotEmpty) {
        final queryString = Uri(queryParameters: params).query;
        url = '$url?$queryString';
      }

      final response = await http.post(
        Uri.parse(url),
        headers: defaultHeaders,
        body: json.encode(body),
      );

      _logRequest('POST', url, defaultHeaders, body, response, params: params);

      final decoded = json.decode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      } else {
        throw Exception('Unexpected response format: ${response.body}');
      }
    } catch (e) {
      print('❌ Exception during POST: $e');
      throw Exception('POST request failed: $e');
    }
  }


  Future<http.Response> deleteDataApiCall({
    required String url,
    Map<String, dynamic>? body, // 👈 now optional
    Map<String, String>? headers,
    String? token,
    Map<String, String>? params,
  }) async {
    final defaultHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    if (params != null && params.isNotEmpty) {
      String queryString = Uri(queryParameters: params).query;
      url = '$url?$queryString';
    }

    final response = await http.delete(
      Uri.parse(url),
      headers: defaultHeaders,
      body: body != null ? json.encode(body) : null, // 👈 only include if exists
    );

    _logRequest('DELETE', url, defaultHeaders, body, response, params: params);

    return response;
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




  Future<String> uploadFileByMultipart({
    required String filePath,
    required String folderName,
    String? url,
    String? authToken,
  }) async {
    try {
      final uploadUrl = ApiServiceUrl.uploadFile;
      print('Uploading to URL: $uploadUrl');  // <--- Add this

      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      if (authToken != null && authToken.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $authToken';
      }

      request.fields.addAll({
        'folderName': folderName,
      });

      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      http.StreamedResponse response = await request.send();

      final responseBody = await response.stream.bytesToString();

      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        return responseBody;
      } else {
        return 'Failed to upload: ${response.reasonPhrase}\n$responseBody';
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
