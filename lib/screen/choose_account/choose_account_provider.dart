import 'package:flutter/material.dart';
import 'package:special_education/api_service/api_calling_types.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/user_data/user_data.dart';

class ChooseAccountProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;


  bool get isLoading => _isLoading;
  String? get error => _error;

  final ApiCallingTypes _api = ApiCallingTypes(
    baseUrl: ApiServiceUrl.apiBaseUrl,
  );

  final UserData _userData = UserData();

  Future<bool> getDataByInstitute({
    required int organizationId,
    required int instituteId,
    required int userRoleId,
  }) async {
    _setLoading(true);

    try {
      final savedUser = _userData.getUserData;
      final token = savedUser.token ?? '';
      final url = "${ApiServiceUrl.apiBaseUrl}${ApiServiceUrl.loginWithInstitute}";

      final response = await _api.postApiCall(
        url: url,
        body: {
          "organizationId": organizationId,
          "instituteId": instituteId,
          "userRoleId": userRoleId,
        },
        token: token,
      );
      if (response["responseStatus"] == true) {
        final data = response["data"];
        if (data != null) {
          await _userData.addUserData(Map<String, dynamic>.from(data));
        }

        return true;
      } else {
        _setError(response["responseMessage"] ?? "Failed to fetch user role");
        return false;
      }
    } catch (e) {
      _setError("Exception: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Private helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    _isLoading = false;
    notifyListeners();
  }
}
