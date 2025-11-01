import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:special_education/api_service/api_calling_types.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/screen/teacher/teacher_data_model.dart';

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
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _api.getApiCall(
        url:
            "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getTeacherList}",
        params: {"instituteId": "22"},
        token: ApiServiceUrl.token,
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body["responseStatus"] == true && body["data"] is List) {
          _teacherData = (body["data"] as List)
              .map(
                (e) =>
                    TeacherListDataModal.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList();

          _filteredTeacherData = List.from(_teacherData!);
          _searchQuery = "";
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

  Future<bool> fetchTeacherProfileDetails( int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _api.getApiCall(
        url:
            "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getTeacherList}",
        params: {"instituteId": "22","id":id.toString()},
        token: ApiServiceUrl.token,
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body["responseStatus"] == true && body["data"] is List) {
          _selectedTeacherData = (body["data"] as List)
              .map(
                (e) =>
                    TeacherListDataModal.fromJson(Map<String, dynamic>.from(e)),
              )
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
              .map(
                (e) =>
                    RoleDataModal.fromJson(Map<String, dynamic>.from(e)),
              )
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

  Future<bool> addTeacher({
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
      final response = await _api.postApiCall(
        url:
            "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.teacherRegistration}",
        body: {
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
          "instituteId": instituteId ?? "",
          "joiningDate": joiningDate?.toIso8601String().split("T")[0],
          "lastName": lastName,
          "middleName": middleName,
          "mobileNumber": mobileNumber,
          "nationalityId": nationalityId,
          "pinCode": pinCode ?? "",
          "roleId": roleId ?? "",
          "signature": signature ?? "",
          "stateId": stateId,
          "image": image,
        },
        token: ApiServiceUrl.token,
      );
      final body = json.decode(response.body);
      if (response.statusCode == 201 && body["responseStatus"] == true) {
        return true;
      }
      _setError(body["responseMessage"] ?? "Something went wrong");
    } catch (e) {
      _setError("Exception: $e");
    } finally {
      _setLoading(false);
    }
    return false;
  }
}
