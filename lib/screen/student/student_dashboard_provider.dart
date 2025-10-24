import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:special_education/api_service/api_calling_types.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/components/custom_api_call.dart';
import 'package:special_education/screen/dashboard/dashboard_data_modal.dart';
import 'package:special_education/screen/student/profile_detail/country_state_data_model.dart';
import 'package:special_education/screen/student/profile_detail/student_profile_data_model.dart';

class StudentDashboardProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  List<StudentListDataModal>? _studentData;
  List<StudentListDataModal>? _filteredStudentData;
  List<LongTermGoal>? _longTermGoalData;
  List<WeeklyGoal>? _weeklyGoalData;
  List<StudentAllVideo>? _allVideoData;


  List<CountryDataModal>? _countryData;
  List<StateDataModel>? _stateData;
  List<CityDataModel>? _cityData;

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

  List<StudentAllVideo>? get allVideoData {
    return _allVideoData;
  }

  List<CountryDataModal>? get countryData {
    return _countryData;
  }
  List<StateDataModel>? get stateData {
    return _stateData;
  }
  List<CityDataModel>? get cityData {
    return _cityData;
  }

  final _api = ApiCallingTypes(baseUrl: ApiServiceUrl.apiBaseUrl);

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> fetchStudentList() async {
    await Future.delayed(Duration(milliseconds: 10));
    _setLoading(true);

    try {
      final response = await _api.getApiCall(
        url:
            "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getStudentByInstituteId}",
        params: {"instituteId": "22"},
        token: ApiServiceUrl.token,
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

  Future<bool> fetchProfileDetail(String id) async {
    await Future.delayed(Duration(milliseconds: 10));
    _setLoading(true);

    try {
      final response = await _api.getApiCall(
        url:
            "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getStudentProfile}",
        params: {"id": id},
        token: ApiServiceUrl.token,
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
        token: ApiServiceUrl.token,
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

  Future<bool> addLongTermCourse(String studentId, String longTermGoal) async {
    await Future.delayed(Duration(milliseconds: 10));
    _setLoading(true);

    try {
      final response = await _api.postApiCall(
        url:
            "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.addLongTermCourse}",
        body: {"studentId": studentId, "longTermGoal": longTermGoal},
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

  Future<bool> updateLongTermCourse(String id, String longTermGoal) async {
    await Future.delayed(Duration(milliseconds: 10));
    _setLoading(true);

    try {
      final response = await _api.putApiCall(
        url:
            "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.updateLongTermGoal}",
        body: {"id": id, "longTermGoal": longTermGoal},
        token: ApiServiceUrl.token,
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
        token: ApiServiceUrl.token,
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
        token: ApiServiceUrl.token,
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

  Future<Map<String, dynamic>> updateWeeklyGoal(
      String studentId,
      String durationDate,
      String goals,
      String intervention,
      String learningBarriers,
      ) async {
    await Future.delayed(Duration(milliseconds: 10));
    _setLoading(true);

    try {
      final response = await _api.putApiCall(
        url:
        "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.updateStudentGoal}",
        body: {
          "id": studentId,
          "goals": goals,
          "intervention": intervention,
          "learningBarriers": learningBarriers,
        },
        token: ApiServiceUrl.token,
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

  Future<bool> getAllVideos(String id) async {
    await Future.delayed(Duration(milliseconds: 10));
    _setLoading(true);

    try {
      final response = await _api.getApiCall(
        url:
        "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getStudentVideos}",
        params: {"studentId": id},
        token: ApiServiceUrl.token,
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200 &&
          body["responseStatus"] == true &&
          body["data"] is List) {
        _allVideoData = (body["data"] as List)
            .map((e) => StudentAllVideo.fromJson(Map<String, dynamic>.from(e)))
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


  Future<bool> addStudent({
    required String firstName,
    String? middleName,
    required String lastName,
    required String mobileNumber,
    String? emailId,
    required String diagnosis,
    required DateTime dob,
    required int genderId,
    required int pidNumber,
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
      final response = await _api.postApiCall(
        url: "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.saveStudent}",
        body: {
          "instituteId": 22,
          "firstName": firstName,
          "middleName": middleName ?? "",
          "lastName": lastName,
          "mobileNumber": mobileNumber,
          "emailId": emailId ?? "",
          "diagnosis": diagnosis,
          "dob": dob.toIso8601String().split("T")[0], // format YYYY-MM-DD
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


  Future<String?> uploadImage(String filePath, BuildContext context) async {
    final apiCaller = ApiCallingTypes(baseUrl: '');

    try {
      String result = await apiCaller.uploadFileByMultipart(
        filePath: filePath,
        folderName: 'Uploads',
        authToken: ApiServiceUrl.token,
      );

      if (result.startsWith('Failed') || result.startsWith('Error')) {
        throw Exception(result);
      }

      final decoded = jsonDecode(result);
      final uploadImageName = decoded['data'];
      if (kDebugMode) {
        print('📁 File Name: $uploadImageName');
      }
      return uploadImageName;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error uploading or updating profile image: $e');
      }
      showSnackBar('Failed to upload image', context);
      return null;
    }
  }


}
