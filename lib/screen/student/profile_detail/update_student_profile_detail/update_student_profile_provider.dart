import 'package:flutter/Material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:special_education/api_service/api_calling_types.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/api_service/response_checker.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/screen/login/login_view.dart';
import 'package:special_education/screen/student/profile_detail/update_student_profile_detail/update_psycho_motor_skill_view/update_psycho_motor_skill_view.dart';
import 'package:special_education/screen/student/profile_detail/update_student_profile_detail/update_student_profile_data_model.dart';
import 'package:special_education/screen/student/student_dashboard_provider.dart';
import 'package:special_education/user_data/user_data.dart';
import 'package:special_education/utils/exception_handle.dart';
import 'package:special_education/utils/navigation_utils.dart';

class UpdateStudentProfileProvider extends ChangeNotifier {
  final ApiCallingTypes _api = ApiCallingTypes(
    baseUrl: ApiServiceUrl.elearningApiBaseUrl,
  );

  final UserData userData = UserData();

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<UpdateStudentProfileDataModel>? _studentProfileData;
  List<UpdateStudentProfileDataModel>? get studentProfileData =>
      _studentProfileData;

  List<UpdateStudentPsychoSkillDataModel>? _psychoSkillData;
  List<UpdateStudentPsychoSkillDataModel>? get psychoSkillData =>
      _psychoSkillData;



  String get _token => userData.getUserData.token.toString();


  Future<bool> getStudentProfileDetail(dynamic context, String id) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _api.getApiCall(
        url:
            "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.student}",
        params: {"id": id},
        token: _token,
      );

      if (response["responseStatus"] == true &&
          response["data"] != null &&
          response["data"] is List &&
          response["data"].isNotEmpty) {
        _studentProfileData = (response["data"] as List)
            .map(
              (e) => UpdateStudentProfileDataModel.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList();

        _setLoading(false);
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        showSnackBar(response["responseMessage"] ?? "No student data found",context);

        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("API ERROR: $e");
      }

      if (e is UnauthorizedException) {
        showSnackBar("Session expired. Please login again.", context);

        Future.delayed(const Duration(milliseconds: 500), () {
          NavigationHelper.pushAndClearStack(context, const LoginPage());
        });
      } else {
        _isLoading = false;
        notifyListeners();
        showSnackBar("Something went wrong. Please try again.",context);
      }

      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateStudentProfile(
      context, {
        required String id,
        required String firstName,
        String? middleName,
        required String lastName,
        required String mobileNumber,
        String? emailId,
        required String diagnosis,
        required DateTime dob,
        required int genderId,
        required String pidNumber,
        String? pinCode,
        String? addressLine1,
        String? addressLine2,
        required int countryId,
        required int stateId,
        required int cityId,
        required int nationalityId,
        required String aadharCardNumber,
        String? aadharCardImageName,
        String? studentImageName,
      }) async {
    _setLoading(true);
    try {
      final data = await _api.putApiCall(
        url: "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.student}",
        body: {
          "id": id,
          "firstName": firstName,
          "middleName": middleName ?? "",
          "lastName": lastName,
          "mobileNumber": mobileNumber,
          "emailId": emailId ?? "",
          "diagnosis": diagnosis,
          "dob": dob.toIso8601String().split("T")[0],
          "genderId": genderId,
          "pidNumber": pidNumber,
          "pinCode": pinCode ?? "",
          "addressLine1": addressLine1 ?? "",
          "addressLine2": addressLine2 ?? "",
          "countryId": countryId,
          "stateId": stateId,
          "cityId": cityId,
          "nationalityId": nationalityId,
          "aadharCardNumber": aadharCardNumber,
          "aadharCardImage": aadharCardImageName ?? "",
          "studentImage": studentImageName ?? "",
        },
        token: _token,
      );

      final ApiResponse apiResp = ResponseChecker.fromRaw(data);

      _setLoading(false);

      if (context is BuildContext) {
        ResponseChecker.showSnackBarFromResponse(context, apiResp);
      } else {
        print(apiResp.success
            ? 'Success: ${apiResp.message}'
            : 'Failure: ${apiResp.message}');
      }
      NavigationHelper.pop(context);
      return apiResp.success;
    } on UnauthorizedException {
      if (context is BuildContext) unauthorizedUser(context);
      return false;
    } catch (e, st) {
      final String err = 'An error occurred: ${e.toString()}';
      if (context is BuildContext) {
        showSnackBar(err, context);
      } else {
        print(err);
      }
      print(st);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> getPsychoStudentSkillData(context, String studentId, String skillId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _api.getApiCall(
        url: "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.studentSkill}",
        params: {"studentId": studentId.toString(),"skillId": skillId.toString()},
        token: _token,
      );
      if (response["responseStatus"] == true && response["data"] is List) {
        _psychoSkillData = (response["data"] as List)
            .map((e) => UpdateStudentPsychoSkillDataModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();


        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        showSnackBar(response["responseMessage"] ?? "Invalid data received",context);
      }
    } catch (e) {
      if (kDebugMode) {
        print("UnauthorizedException");
      }
      if (e is UnauthorizedException) {
        if (context is BuildContext) unauthorizedUser(context);
      }
    }

    notifyListeners();
    return false;
  }

  void updateChildSkillRating(int parentId, int ratingId) {
    final skills = _psychoSkillData?.first.skillQuality ?? [];

    for (final skill in skills) {
      final children = skill.skillQualityParent ?? [];

      for (final child in children) {
        if (child.qualityParentId == parentId) {
          child.ratingId = ratingId;
          notifyListeners();
          return;
        }
      }
    }
  }



}
