import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:special_education/api_service/api_calling_types.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/screen/teacher/teacher_data_model.dart';
import 'package:special_education/user_data/user_data.dart';
import 'package:special_education/utils/navigation_utils.dart';
import 'package:http/http.dart';

class TeacherDashboardProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;

  String? get error => _error;

  List<TeacherListDataModal>? _teacherData;
  List<TeacherListDataModal>? _selectedTeacherData;
  List<TeacherListDataModal>? _filteredTeacherData;
  List<RoleDataModal>? _roleData;

  String _searchQuery = "";

  final UserData userData = UserData();
  late var token = userData.getUserData.token;
  late var instituteId = userData.getUserData.instituteId ?? "0";

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    _isLoading = false;
    notifyListeners();
  }

  final _api = ApiCallingTypes(baseUrl: '');

  List<TeacherListDataModal>? get teacherData {
    if (_searchQuery.isEmpty) {
      return _teacherData;
    } else {
      return _filteredTeacherData;
    }
  }

  List<TeacherListDataModal>? get selectedTeacherData {
    return _selectedTeacherData;
  }

  Future<bool> fetchTeacherList() async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _api.getApiCall(
        url:
        "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl
            .getTeacherList}",
        params: {"instituteId": instituteId.toString()},
        token: token,
      );

      if (response["responseStatus"] == true && response["data"] is List) {
        _teacherData = (response["data"] as List)
            .map(
              (e) =>
              TeacherListDataModal.fromJson(Map<String, dynamic>.from(e)),
        )
            .toList();

        _filteredTeacherData = List.from(_teacherData!);
        _searchQuery = "";

        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(response["responseMessage"] ?? "Invalid data received");
      }
    } catch (e) {
      _setError("Exception: $e");
      if (kDebugMode) print("fetchTeacherList Exception: $e");
    }

    _setLoading(false);
    notifyListeners();
    return false;
  }

  Future<bool> fetchTeacherProfileDetails(int id) async {
    _setLoading(true);
    _error = null;

    try {
      final response = await _api.getApiCall(
        url:
        "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl
            .getTeacherList}",
        params: {"instituteId": instituteId.toString(), "id": id.toString()},
        token: token,
      );

      if (response["responseStatus"] == true && response["data"] is List) {
        _selectedTeacherData = (response["data"] as List)
            .map(
              (e) =>
              TeacherListDataModal.fromJson(Map<String, dynamic>.from(e)),
        )
            .toList();

        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(response["responseMessage"] ?? "Invalid data received");
      }
    } catch (e) {
      _setError("Exception: $e");
      if (kDebugMode) print("fetchTeacherProfileDetails Exception: $e");
    }

    _setLoading(false);
    notifyListeners();
    return false;
  }

  Future<bool> fetchRole() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _api.getApiCall(
        url:
        "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.masterRole}",
        params: {"": ""},
        token: ApiServiceUrl.token,
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body["responseStatus"] == true && body["data"] is List) {
          _roleData = (body["data"] as List)
              .map((e) => RoleDataModal.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } else {
          _error = body["responseMessage"] ?? "Invalid data received";
        }
      } else {
        _error = "Server error: ${response.statusCode}";
      }
    } catch (e) {
      _error = "Exception: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return _teacherData != null && _teacherData!.isNotEmpty;
  }

  Future<bool> deleteTeacher(BuildContext context, String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _api.deleteDataApiCall(
        url:
        "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl
            .deleteTeacherById}",
        params: {"id": id},
        token: token,
      );

      final body = json.decode(response.body);

      if (response.statusCode == 200 && body["responseStatus"] == true) {
        await fetchTeacherList();

        if (context.mounted) {
          showSnackBar(body["responseMessage"], context);
        }
      } else {
        _error = body["responseMessage"] ?? "Invalid data received";
      }
    } catch (e) {
      _error = "Exception: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _teacherData != null && _teacherData!.isNotEmpty;
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      _filteredTeacherData = null;
    } else {
      _filteredTeacherData = _teacherData?.where((teacher) {
        final name = teacher.teacherName?.toLowerCase() ?? '';
        final employeeId = teacher.employeeId?.toString().toLowerCase() ?? '';
        final mobileNumber = teacher.mobileNumber?.toLowerCase() ?? '';

        return name.contains(_searchQuery) ||
            employeeId.contains(_searchQuery) ||
            mobileNumber.contains(_searchQuery);
      }).toList();
    }
    notifyListeners();
  }


  Future<bool> addAndUpdateTeacher(
      BuildContext context, {
        required bool isUpdatingProfile,
        int? id,
        String? aadharCardImage,
        String? aadharCardNumber,
        String? addressLine1,
        String? addressLine2,
        required int cityId,
        required int countryId,
        required DateTime dateOfBirth,
        String? emailId,
        required String employeeId,
        required String firstName,
        required int genderId,
        int? instituteId,
        DateTime? joiningDate,
        String? lastName,
        String? middleName,
        required String mobileNumber,
        required int nationalityId,
        String? pinCode,
        int? roleId,
        String? signature,
        required int stateId,
        String? image,
      }) async {
    _setLoading(true);

    try {

      final body = {
        "id": isUpdatingProfile ? id : null,
        "aadharCardImage": aadharCardImage,
        "aadharCardNumber": aadharCardNumber,
        "addressLine1": addressLine1,
        "addressLine2": addressLine2,
        "cityId": cityId,
        "countryId": countryId,
        "dateOfBirth": dateOfBirth.toIso8601String().split("T")[0],
        "emailId": emailId ?? "",
        "employeeId": employeeId,
        "firstName": firstName,
        "genderId": genderId,
        "instituteId": instituteId,
        "joiningDate": joiningDate?.toIso8601String().split("T")[0],
        "lastName": lastName,
        "middleName": middleName,
        "mobileNumber": mobileNumber,
        "nationalityId": nationalityId,
        "pinCode": pinCode ?? "",
        "roleId": roleId,
        "signature": signature ?? "",
        "stateId": stateId,
        "image": image,
      };

      final url =
          "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${isUpdatingProfile ? ApiServiceUrl.teacherUpdate : ApiServiceUrl.teacherRegistration}";

      final data = isUpdatingProfile
          ? await _api.putApiCall(url: url, body: body, token: token)
          : await _api.postApiCall(url: url, body: body, token: token);

      Map<String, dynamic> res = data is Response ? jsonDecode(data.body) : data;

      if (res["responseStatus"] == true) {
        showSnackBar(res["responseMessage"] ?? "Operation successful", context);

        if (isUpdatingProfile) {
          NavigationHelper.pop(context);
        }
        NavigationHelper.pop(context);
        return true;
      } else {
        showSnackBar(res["responseMessage"] ?? "Operation failed", context);
      }
    } catch (e) {
      _setError("Exception: $e");
      print("Error in saveTeacher: $e");
    } finally {
      _setLoading(false);
    }

    return false;
  }


}