import 'dart:convert';
import 'package:flutter/material.dart';

class ApiResponse {
  final bool success;
  final String message;
  final dynamic data;
  final dynamic raw;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.raw,
  });

  @override
  String toString() => 'ApiResponse(success: $success, message: $message, data: $data)';
}

class ResponseChecker {
  /// Convert many possible raw response shapes into ApiResponse.
  /// Handles:
  ///  - Map<String, dynamic> directly,
  ///  - Map (non-generic),
  ///  - Objects with `.body` (e.g. http.Response),
  ///  - JSON string,
  ///  - objects that expose properties (raw.responseStatus/raw.responseMessage).
  static ApiResponse fromRaw(dynamic raw) {
    // fast path: already a Map<String, dynamic>
    Map<String, dynamic>? map;
    try {
      if (raw == null) {
        return ApiResponse(success: false, message: 'Empty response', data: null, raw: raw);
      }

      if (raw is Map<String, dynamic>) {
        map = raw;
      } else if (raw is Map) {
        map = Map<String, dynamic>.from(raw);
      } else {
        // try common places (body or toString)
        try {
          final candidate = raw?.body ?? raw?.toString();
          if (candidate != null) {
            final decoded = jsonDecode(candidate);
            if (decoded is Map<String, dynamic>) map = decoded;
          }
        } catch (_) {
          // ignore decode errors
        }

        // if still null, try property access (some wrappers expose fields)
        if (map == null) {
          try {
            final dynStatus = raw?.responseStatus;
            final dynMessage = raw?.responseMessage;
            final dynData = raw?.data;

            if (dynStatus != null || dynMessage != null || dynData != null) {
              map = <String, dynamic>{
                if (dynStatus != null) 'responseStatus': dynStatus,
                if (dynMessage != null) 'responseMessage': dynMessage,
                if (dynData != null) 'data': dynData,
              };
            }
          } catch (_) {
            // ignore
          }
        }
      }

      // If we still don't have a map, try final fallback: parse raw.toString()
      if (map == null) {
        try {
          final decoded2 = jsonDecode(raw.toString());
          if (decoded2 is Map<String, dynamic>) map = decoded2;
        } catch (_) {
          // ignore
        }
      }
    } catch (e) {
      // defensive fallback
      return ApiResponse(
        success: false,
        message: 'Error parsing response: ${e.toString()}',
        data: null,
        raw: raw,
      );
    }

    if (map == null) {
      // Could not interpret response as JSON/map — return raw string as message
      final String rawStr = raw?.toString() ?? 'null';
      return ApiResponse(success: false, message: 'Invalid response format: $rawStr', data: null, raw: raw);
    }

    // Extract responseStatus in a robust way
    final dynamic statusValue = map['responseStatus'] ?? map['status'] ?? map['success'];
    bool success = false;
    if (statusValue is bool) {
      success = statusValue;
    } else if (statusValue is String) {
      final s = statusValue.toLowerCase();
      success = (s == 'true' || s == '1' || s == 'success' || s == 'ok');
    } else if (statusValue is num) {
      success = statusValue == 1;
    } else {
      success = false;
    }

    // message fallback chain
    final String message = (map['responseMessage'] ??
        map['message'] ??
        map['msg'] ??
        (success ? 'Success' : 'Invalid response from server'))
        .toString();

    final dynamic data = map.containsKey('data') ? map['data'] : null;

    return ApiResponse(success: success, message: message, data: data, raw: raw);
  }

  /// Convenience: show snackbar if context provided
  static void showSnackBarFromResponse(BuildContext? context, ApiResponse resp) {
    if (context == null) {
      print('ApiResponse: ${resp.toString()}');
      return;
    }
    final snack = SnackBar(content: Text(resp.message));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}
