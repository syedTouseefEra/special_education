import 'dart:convert';

import 'package:special_education/api_service/api_calling_types.dart';
import 'package:special_education/api_service/api_service_url.dart';

class LocationService {
  final ApiCallingTypes _api = ApiCallingTypes(baseUrl: ApiServiceUrl.apiBaseUrl);
  Future<List<T>> fetchLocationData<T>({
    required String url,
    Map<String, String>? params,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _api.getApiCall(
        url: url,
        params: params ?? {},
        token: ApiServiceUrl.token,
      );
      final body = response is Map<String, dynamic>
          ? response
          : json.decode(response.body);

      if (body["responseStatus"] == true && body["data"] is List) {
        return (body["data"] as List)
            .map((e) => fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else {
        throw Exception(body["responseMessage"] ?? "Something went wrong");
      }
    } catch (e) {
      rethrow;
    }
  }



}

