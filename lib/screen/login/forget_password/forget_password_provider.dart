import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:special_education/api_service/api_calling_types.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/user_data/user_data.dart';
import 'package:special_education/utils/navigation_utils.dart';

class ForgetPasswordProvider extends ChangeNotifier {
  final ApiCallingTypes _api = ApiCallingTypes(
    baseUrl: ApiServiceUrl.elearningApiBaseUrl,
  );

  final UserData userData = UserData();
  late var token = userData.getUserData.token;
  var newToken = '';

  Future<bool> generateOtp(String mobileNo, BuildContext context) async {
    try {
      final url =
          "${ApiServiceUrl.elearningApiBaseUrl}${ApiServiceUrl.generateOtp}";
      final response = await _api.postApiCall(
        token: token,
        url: url,
        body: {"mobileNo": mobileNo},
      );

      if (response["responseStatus"] == true) {
        showSnackBar(response["responseMessage"], context);
        return true;
      } else {
        showSnackBar(
          response["responseMessage"] ?? "Failed to fetch user role",
          context,
        );
        return false;
      }
    } catch (e) {
      print("Error in generateOtp: $e");
      return false;
    }
  }

  Future<bool> verifyOtp(
    String mobileNo,
    String otp,
    BuildContext context,
  ) async {
    try {
      final url =
          "${ApiServiceUrl.elearningApiBaseUrl}${ApiServiceUrl.verifyOtp}";
      final response = await _api.putApiCall(
        token: token,
        url: url,
        body: {"mobileNo": mobileNo, 'otp': otp},
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['responseStatus'] == true) {
        showSnackBar(body['responseMessage'] ?? 'Otp Verified!', context);
        newToken = body['data']['token'];

        return true;
      } else {
        showSnackBar(
          body['responseMessage'] ?? 'Password change failed',
          context,
        );
        return false;
      }
    } catch (e) {
      print("Error in generateOtp: $e");
      return false;
    }
  }

  Future<bool> forgotPassword(String newPassword, BuildContext context) async {
    try {
      final url =
          "${ApiServiceUrl.elearningApiBaseUrl}${ApiServiceUrl.forgotPassword}";
      final response = await _api.putApiCall(
        token: newToken,
        url: url,
        body: {"newPassword": newPassword},
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['responseStatus'] == true) {
        showSnackBar(body['responseMessage'] ?? 'New Password Generated!', context);
        NavigationHelper.pop(context);
        return true;
      } else {
        showSnackBar(
          body['responseMessage'] ?? 'Password change failed',
          context,
        );
        return false;
      }
    } catch (e) {
      print("Error in generateOtp: $e");
      return false;
    }
  }
}
