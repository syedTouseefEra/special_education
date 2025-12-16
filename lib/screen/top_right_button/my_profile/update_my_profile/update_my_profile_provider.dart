

import 'dart:convert';

import 'package:flutter/Material.dart';
import 'package:special_education/api_service/api_calling_types.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/user_data/user_data.dart';

class UpdateMyProfileProvider extends ChangeNotifier {
  final ApiCallingTypes _api = ApiCallingTypes(
    baseUrl: ApiServiceUrl.elearningApiBaseUrl,
  );

  final UserData userData = UserData();
  late var token = userData.getUserData.token;
  late var instituteId = userData.getUserData.instituteId ?? "0";

  Future<bool> updateMyProfile(
      BuildContext context, {
        required String firstName,
        required String middleName,
        required String lastName,
        required String mobileNumber,
        required String emailId,
        required String employeeId,
        required String dateOfBirth,
        required int genderId,
        required String pinCode,
        required String addressLine1,
        required String addressLine2,
        required int countryId,
        required int stateId,
        required int cityId,
        required String designation,
        required int roleId,
        required String joiningDate,
        required int nationalityId,
        required String aadharCardNumber,
        required String aadharCardImage,
        required String studentImage,
        required String signature,
      }) async {
    try {
      final url =
          "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.teacherProfileUpdate}";

      final response = await _api.putApiCall(
        token: token,
        url: url,
        body: {
          "instituteId": instituteId,
          "firstName": firstName,
          "middleName": middleName,
          "lastName": lastName,
          "mobileNumber": mobileNumber,
          "emailId": emailId,
          "employeeId": employeeId,
          "designation:": designation,
          "dateOfBirth": dateOfBirth,
          "genderId": genderId,
          "pinCode": pinCode,
          "addressLine1": addressLine1,
          "addressLine2": addressLine2,
          "countryId": countryId,
          "stateId": stateId,
          "cityId": cityId,
          "roleId": roleId,
          "joiningDate": joiningDate,
          "nationalityId": nationalityId,
          "aadharCardNumber": aadharCardNumber,
          "aadharCardImage": aadharCardImage,
          "studentImage": studentImage,
          "signature": signature,
        },
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['responseStatus'] == true) {
        showSnackBar(body['responseMessage'] ?? 'Profile Updated!', context);
        return true;
      } else {
        showSnackBar(body['responseMessage'] ?? 'Profile Update failed', context);
        return false;
      }
    } catch (e) {
      print("Error in updateMyProfile: $e");
      return false;
    }
  }

}