import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:special_education/api_service/api_calling_types.dart';
import 'package:special_education/api_service/api_service_url.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _userData;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get userData => _userData;

  final ApiCallingTypes _api = ApiCallingTypes(
    baseUrl: ApiServiceUrl.apiBaseUrl,
  );
  final GetStorage _userBox = GetStorage('user');

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final url = "${ApiServiceUrl.apiBaseUrl}${ApiServiceUrl.login}";
      final response = await _api.postApiCall(
        url: url,
        body: {"mobileNo": username, "password": password},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["responseStatus"] == true) {
          _userData = data["data"];
          await _userBox.write('userData', _userData);
          _isLoading = false;
          getUserRole();
          notifyListeners();
          return true;
        } else {
          _error = data["responseMessage"] ?? "Login failed";
        }
      } else {
        _error = "Server error: ${response.statusCode}";
      }
    } catch (e) {
      _error = "Exception: $e";
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> getUserRole() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final saved = _userBox.read('userData');
      if (saved == null) {
        _error = "No user data found";
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final token = saved["token"];
      final url = "${ApiServiceUrl.apiBaseUrl}${ApiServiceUrl.getUserRole}";

      final response = await _api.getApiCall(
        url: url,
        params: {},
        token: token,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["responseStatus"] == true) {
          _userData = data["data"];
          await _userBox.write('userData', _userData);
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _error = data["responseMessage"] ?? "Failed to fetch user role";
        }
      } else {
        _error = "Server error: ${response.statusCode}";
      }
    } catch (e) {
      _error = "Exception: $e";
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  void loadUserData() {
    final saved = _userBox.read('userData');
    if (saved != null) {
      _userData = Map<String, dynamic>.from(saved);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _userData = null;
    await _userBox.remove('userData');
    notifyListeners();
  }
}
