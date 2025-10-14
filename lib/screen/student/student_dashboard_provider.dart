import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:special_education/api_service/api_calling_types.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/screen/dashboard/dashboard_data_modal.dart';
import 'package:special_education/screen/student/profile_detail/widget/student_profile_data_model.dart';

class StudentDashboardProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  List<StudentListDataModal>? _studentData;
  List<StudentListDataModal>? _filteredStudentData;
  List<LongTermGoal>? _longTermGoalData;
  List<WeeklyGoal>? _weeklyGoalData;

  List<StudentProfileDataModel>? _studentProfileData;

  String _searchQuery = "";

  bool get isLoading => _isLoading;
  String? get error => _error;

  List<StudentListDataModal>? get studentData {
    if (_searchQuery.isEmpty) {
      return _studentData;
    } else {
      return _filteredStudentData;
    }
  }

  List<StudentProfileDataModel>? get studentProfileData {
    return _studentProfileData;
  }

  List<LongTermGoal>? get longTermGoalData {
    return _longTermGoalData;
  }

  List<WeeklyGoal>? get weeklyGoalData {
    return _weeklyGoalData;
  }

  final _api = ApiCallingTypes(baseUrl: ApiServiceUrl.apiBaseUrl);

  static const String _token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwcmltYXJ5c2lkIjoiMTAiLCJyb2xlIjoiMTAiLCJuYW1laWQiOiJBaG1hZCBCaWxhbCBTaWRkaXF1aSIsInByaW1hcnlncm91cHNpZCI6IjgiLCJpbnN0aXR1dGVJZCI6IjIyIiwibmJmIjoxNzYwNDIwMDMwLCJleHAiOjE3NjA0ODAwMzAsImlhdCI6MTc2MDQyMDAzMH0.wK3qKAfiPPPwNDQ2BQW9RDfCOJQ-C8L-ZrpZCGEuuW4';

  Future<bool> fetchStudentList() async {
    await Future.delayed(Duration(milliseconds: 10));
    _setLoading(true);

    try {
      final response = await _api.getApiCall(
        url:
            "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getStudentByInstituteId}",
        params: {"instituteId": "22"},
        token: _token,
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body["responseStatus"] == true && body["data"] is List) {
          _studentData = (body["data"] as List)
              .map(
                (e) =>
                    StudentListDataModal.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList();

          // Reset filtered data on new fetch
          _filteredStudentData = null;
          _searchQuery = "";

          _setLoading(false);
          return true;
        } else {
          _setError(body["responseMessage"] ?? "Invalid data received");
        }
      } else {
        _setError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      _setError("Exception: $e");
    }

    return false;
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();

    if (_searchQuery.isEmpty) {
      _filteredStudentData = null;
    } else {
      _filteredStudentData = _studentData?.where((student) {
        final name = student.studentName?.toLowerCase() ?? '';
        final pid = student.pidNumber?.toString().toLowerCase() ?? '';
        final diagnosis = student.diagnosis?.toLowerCase() ?? '';

        return name.contains(_searchQuery) ||
            pid.contains(_searchQuery) ||
            diagnosis.contains(_searchQuery);
      }).toList();
    }

    notifyListeners();
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

  Future<bool> fetchProfileDetail(String id) async {
    await Future.delayed(Duration(milliseconds: 10));
    _setLoading(true);

    try {
      final response = await _api.getApiCall(
        url:
            "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getStudentProfile}",
        params: {"id": id},
        token: _token,
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body["responseStatus"] == true && body["data"] is List) {
          _studentProfileData = (body["data"] as List)
              .map(
                (e) => StudentProfileDataModel.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList();

          _setLoading(false);
          return true;
        } else {
          _setError(body["responseMessage"] ?? "Invalid data received");
        }
      } else {
        _setError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      _setError("Exception: $e");
    }

    return false;
  }

  Future<bool> getLongTermGoal(String id) async {
    await Future.delayed(Duration(milliseconds: 10));
    _setLoading(true);

    try {
      final response = await _api.getApiCall(
        url:
            "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getLongTermGoal}",
        params: {"studentId": id},
        token: _token,
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200 &&
          body["responseStatus"] == true &&
          body["data"] is List) {
        _longTermGoalData = (body["data"] as List)
            .map((e) => LongTermGoal.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        _setLoading(false);
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

  Future<bool> addLongTermCourse(String studentId, String longTermGoal) async {
    await Future.delayed(Duration(milliseconds: 10));
    _setLoading(true);

    try {
      final response = await _api.postApiCall(
        url:
            "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.addLongTermCourse}",
        body: {"studentId": studentId, "longTermGoal": longTermGoal},
        token: _token,
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

  Future<bool> updateLongTermCourse(String id, String longTermGoal) async {
    await Future.delayed(Duration(milliseconds: 10));
    _setLoading(true);

    try {
      final response = await _api.putApiCall(
        url:
            "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.updateLongTermGoal}",
        body: {"id": id, "longTermGoal": longTermGoal},
        token: _token,
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200 && body["responseStatus"] == true) {
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

  Future<bool> getWeeklyGoals(String id) async {
    await Future.delayed(Duration(milliseconds: 10));
    _setLoading(true);

    try {
      final response = await _api.getApiCall(
        url:
            "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getStudentGoals}",
        params: {"studentId": id},
        token: _token,
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200 &&
          body["responseStatus"] == true &&
          body["data"] is List) {
        _weeklyGoalData = (body["data"] as List)
            .map((e) => WeeklyGoal.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        _setLoading(false);
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

  Future<Map<String, dynamic>> addWeeklyGoal(
      String studentId,
      String durationDate,
      String goals,
      String intervention,
      String learningBarriers,
      ) async {
    await Future.delayed(Duration(milliseconds: 10));
    _setLoading(true);

    try {
      final response = await _api.postApiCall(
        url:
        "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.saveStudentGoals}",
        body: {
          "studentId": studentId,
          "durationDate": durationDate,
          "goals": goals,
          "intervention": intervention,
          "learningBarriers": learningBarriers,
        },
        token: _token,
      );

      final body = json.decode(response.body);

      return body;
    } catch (e) {
      return {
        "responseStatus": false,
        "responseMessage": "Exception: $e",
      };
    } finally {
      _setLoading(false);
    }
  }

}
