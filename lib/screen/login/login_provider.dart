import 'package:flutter/Material.dart';
import 'package:flutter/foundation.dart';
import 'package:special_education/api_service/api_calling_types.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/screen/choose_account/choose_account_data_model.dart';
import 'package:special_education/screen/choose_account/choose_account_view.dart';
import 'package:special_education/screen/login/login_view.dart';
import 'package:special_education/user_data/user_data.dart';
import 'package:special_education/utils/navigation_utils.dart';

class LoginProvider with ChangeNotifier {
  final ApiCallingTypes _api = ApiCallingTypes(baseUrl: ApiServiceUrl.apiBaseUrl);
  final UserData _userData = UserData();

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Login API
  Future<bool> login(String username, String password, BuildContext context) async {
    _setLoading(true);

    try {
      final url = "${ApiServiceUrl.apiBaseUrl}${ApiServiceUrl.login}";
      final response = await _api.postApiCall(
        url: url,
        body: {"mobileNo": username, "password": password},
      );

      if (response['responseStatus'] == true && response['data'] != null) {
        await _userData.addUserData(Map<String, dynamic>.from(response['data']));
        await _userData.setSession(true);

        await getUserRole(context);

        _setLoading(false);
        return true;
      } else {
        _showError(context, response['responseMessage'] ?? 'Login failed');
      }
    } catch (e) {
      _showError(context, "API Error: ${e.toString()}");
    }

    _setLoading(false);
    return false;
  }

  Future<bool> getUserRole(BuildContext context) async {
    _setLoading(true);

    try {
      final savedUser = _userData.getUserData;
      final token = savedUser.token ?? '';
      final url = "${ApiServiceUrl.apiBaseUrl}${ApiServiceUrl.getUserRole}";

      final response = await _api.getApiCall(url: url, params: {}, token: token);

      if (response['responseStatus'] == true && response['data'] is List) {
        final accountList = (response['data'] as List)
            .map((item) => ChooseAccountDataModel.fromJson(item))
            .toList();

        NavigationHelper.replacePush(
          context,
          ChooseAccountView(chooseAccountData: accountList),
        );

        _setLoading(false);
        return true;
      } else {
        _showError(context, response['responseMessage'] ?? 'Failed to fetch user role');
      }
    } catch (e) {
      _showError(context, 'API Error: ${e.toString()}');
    }

    _setLoading(false);
    return false;
  }

  void _showError(BuildContext context, String message) {
    _error = message;
    notifyListeners();
    showSnackBar( message,context,);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Logout function
  Future<void> logout(BuildContext context) async {
    await _userData.removeUserData();
    await _userData.setSession(false);

    NavigationHelper.replacePush(context, const LoginPage());
  }
}

