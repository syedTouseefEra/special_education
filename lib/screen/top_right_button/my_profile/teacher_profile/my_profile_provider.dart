

import 'package:flutter/cupertino.dart';
import 'package:special_education/api_service/api_calling_types.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/screen/login/login_view.dart';
import 'package:special_education/screen/top_right_button/my_profile/teacher_profile/my_profile_data_model.dart';
import 'package:special_education/user_data/user_data.dart';
import 'package:special_education/utils/exception_handle.dart';
import 'package:special_education/utils/navigation_utils.dart';

class MyProfileProvider extends ChangeNotifier{

  final _api = ApiCallingTypes(baseUrl: ApiServiceUrl.elearningApiBaseUrl);

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  final UserData userData = UserData();
  late var token = userData.getUserData.token;
  late var instituteId = userData.getUserData.instituteId ?? "0";

  List<MyProfileDataModel>? _myProfileData;
  List<MyProfileDataModel>? get myProfileData {
    return _myProfileData;
  }


  Future<bool> getTeacherProfileData(dynamic context,) async {
    await Future.delayed(const Duration(milliseconds: 10));
    _setLoading(true);
    try {
      final response = await _api.getApiCall(
        url:
        "${ApiServiceUrl.elearningApiBaseUrl}${ApiServiceUrl.getProfile}",
        params: {"instituteId": instituteId.toString()},
        token: token,
      );

      if (response["responseStatus"] == true && response["data"] is List) {
        _myProfileData = (response["data"] as List)
            .map(
              (e) => MyProfileDataModel.fromJson(
            Map<String, dynamic>.from(e),
          ),
        )
            .toList();
        _setLoading(false);
        return true;
      } else {
        _setError(response["responseMessage"] ?? "Invalid data received");
      }
    } catch (e) {
      if (e is UnauthorizedException) {
        showSnackBar("Session expired. Please login again.", context);
        Future.delayed(const Duration(milliseconds: 500), () {
          NavigationHelper.pushAndClearStack(context, LoginPage());
        });
        return false;
      }
    }
    return false;
  }

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