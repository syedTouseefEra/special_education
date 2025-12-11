import 'dart:convert';

import 'package:flutter/Material.dart';
import 'package:special_education/api_service/api_calling_types.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/user_data/user_data.dart';
import 'package:special_education/utils/navigation_utils.dart';

class ChangePasswordProvider extends ChangeNotifier {
  final ApiCallingTypes _api = ApiCallingTypes(
    baseUrl: ApiServiceUrl.elearningApiBaseUrl,
  );

  final UserData userData = UserData();
  late var token = userData.getUserData.token;

  Future<bool> changePassword(
    String oldPassword,
    String newPassword,
    BuildContext context,
  ) async {
    try {
      final url =
          "${ApiServiceUrl.elearningApiBaseUrl}${ApiServiceUrl.changePassword}";
      final response = await _api.putApiCall(
        token: token,
        url: url,
        body: {"oldPassword": oldPassword, "newPassword": newPassword},
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['responseStatus'] == true) {
        showSnackBar(
          body['responseMessage'] ?? 'Password changed successfully',
          context,
        );
        NavigationHelper.pop(context);
      } else {
        showSnackBar(
          body['responseMessage'] ?? 'Password change failed',
          context,
        );
      }
    } catch (e) {
      showSnackBar('Something went wrong: $e', context);
    }
    return false;
  }
}
