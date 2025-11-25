import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:special_education/api_service/api_calling_types.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/screen/dashboard/dashboard_data_modal.dart';
import 'package:special_education/screen/login/login_view.dart';
import 'package:special_education/screen/student/profile_detail/country_state_data_model.dart';
import 'package:special_education/screen/student/profile_detail/student_profile_data_model.dart';
import 'package:special_education/user_data/user_data.dart';
import 'package:special_education/utils/exception_handle.dart';
import 'package:special_education/utils/navigation_utils.dart';

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

  final UserData userData = UserData();
  late var token = userData.getUserData.token;
  late var instituteId = userData.getUserData.instituteId ?? "0";


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

  Future<bool> fetchStudentList(context) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _api.getApiCall(
        url: "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getStudentByInstituteId}",
        params: {"instituteId": instituteId.toString()},
        token: token,
      );
      if (response["responseStatus"] == true && response["data"] is List) {
        _studentData = (response["data"] as List)
            .map((e) => StudentListDataModal.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        _filteredStudentData = null;
        _searchQuery = "";

        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(response["responseMessage"] ?? "Invalid data received");
      }
    } catch (e) {
      if (kDebugMode) {
        print("UnauthorizedException");
      }
      if (e is UnauthorizedException) {
        showSnackBar("Session expired. Please login again.", context);
        Future.delayed(const Duration(milliseconds: 500), () {
          NavigationHelper.pushAndClearStack(context, LoginPage());
        });
        return false;
      }
    }

    notifyListeners();
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

  Future<bool> fetchProfileDetail(dynamic context,String id) async {
    await Future.delayed(const Duration(milliseconds: 10));
    _setLoading(true);

    try {

      final response = await _api.getApiCall(
        url:
        "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getStudentProfile}",
        params: {"id": id},
        token: token,
      );

      if (response["responseStatus"] == true && response["data"] is List) {
        _studentProfileData = (response["data"] as List)
            .map((e) => StudentProfileDataModel.fromJson(
          Map<String, dynamic>.from(e),
        ))
            .toList();
        _setLoading(false);
        return true;
      } else {
        _setError(response["responseMessage"] ?? "Invalid data received");
      }
    } catch (e) {
      if (kDebugMode) {
        print("UnauthorizedException");
      }
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

  Future<bool> getLongTermGoal(dynamic context,String id) async {
    await Future.delayed(const Duration(milliseconds: 10));
    _setLoading(true);

    try {
      final response = await _api.getApiCall(
        url:
        "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getLongTermGoal}",
        params: {"studentId": id},
        token: token,
      );

      if (response["responseStatus"] == true && response["data"] is List) {
        _weeklyGoalData = (response["data"] as List)
            .map((e) => WeeklyGoal.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        _setLoading(false);
        return true;
      } else {
        _setError(response["responseMessage"] ?? "Something went wrong");
      }
    } catch (e) {
      if (kDebugMode) {
        print("UnauthorizedException");
      }
      if (e is UnauthorizedException) {
        showSnackBar("Session expired. Please login again.", context);
        Future.delayed(const Duration(milliseconds: 500), () {
          NavigationHelper.pushAndClearStack(context, LoginPage());
        });
        return false;
      }
    } finally {
      _setLoading(false);
    }

    return false;
  }


  // Future<bool> addLongTermCourse(String studentId, String longTermGoal) async {
  //   await Future.delayed(Duration(milliseconds: 10));
  //   _setLoading(true);
  //
  //   try {
  //     final response = await _api.postApiCall(
  //       url:
  //           "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.addLongTermCourse}",
  //       body: {"studentId": studentId, "longTermGoal": longTermGoal},
  //       token: ApiServiceUrl.token,
  //     );
  //     final body = json.decode(response.body);
  //     if (response.statusCode == 201 && body["responseStatus"] == true) {
  //       return true;
  //     }
  //     _setError(body["responseMessage"] ?? "Something went wrong");
  //   } catch (e) {
  //     _setError("Exception: $e");
  //   } finally {
  //     _setLoading(false);
  //   }
  //
  //   return false;
  // }

  Future<bool> addLongTermCourse(dynamic context,String studentId, String longTermGoal) async {
    _setLoading(true);

    try {
      final data = await _api.postApiCall(
        url: "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.addLongTermCourse}",
        body: {
          "studentId": studentId,
          "longTermGoal": longTermGoal,
        },
        token: token,
      );

      if (data["responseStatus"] == true) {
        return true;
      } else {
        _setError(data["responseMessage"] ?? "Something went wrong");
      }
    } catch (e) {
      if (kDebugMode) {
        print("UnauthorizedException");
      }
      if (e is UnauthorizedException) {
        showSnackBar("Session expired. Please login again.", context);
        Future.delayed(const Duration(milliseconds: 500), () {
          NavigationHelper.pushAndClearStack(context, LoginPage());
        });
        return false;
      }
    } finally {
      _setLoading(false);
    }
    return false;
  }


  Future<bool> updateLongTermCourse(dynamic context,String id, String longTermGoal) async {
    await Future.delayed(Duration(milliseconds: 10));
    _setLoading(true);

    try {
      final response = await _api.putApiCall(
        url:
            "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.updateLongTermGoal}",
        body: {"id": id, "longTermGoal": longTermGoal},
        token: token,
      );
      final body = json.decode(response.body);
      if (response.statusCode == 200 && body["responseStatus"] == true) {
        return true;
      }
      _setError(body["responseMessage"] ?? "Something went wrong");
    } catch (e) {
      if (kDebugMode) {
        print("UnauthorizedException");
      }
      if (e is UnauthorizedException) {
        showSnackBar("Session expired. Please login again.", context);
        Future.delayed(const Duration(milliseconds: 500), () {
          NavigationHelper.pushAndClearStack(context, LoginPage());
        });
        return false;
      }
    } finally {
      _setLoading(false);
    }

    return false;
  }

  Future<bool> getWeeklyGoals(dynamic context,String id) async {
    await Future.delayed(const Duration(milliseconds: 10));
    _setLoading(true);

    try {
      final response = await _api.getApiCall(
        url: "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getStudentGoals}",
        params: {"studentId": id},
        token: token,
      );

      if (response["responseStatus"] == true && response["data"] is List) {
        _weeklyGoalData = (response["data"] as List)
            .map((e) => WeeklyGoal.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        _setLoading(false);
        return true;
      } else {
        _setError(response["responseMessage"] ?? "Something went wrong");
      }
    } catch (e) {
      if (kDebugMode) {
        print("UnauthorizedException");
      }
      if (e is UnauthorizedException) {
        showSnackBar("Session expired. Please login again.", context);
        Future.delayed(const Duration(milliseconds: 500), () {
          NavigationHelper.pushAndClearStack(context, LoginPage());
        });
        return false;
      }
    } finally {
      _setLoading(false);
    }

    return false;
  }


  // Future<Map<String, dynamic>> addWeeklyGoal(
  //     String studentId,
  //     String durationDate,
  //     String goals,
  //     String intervention,
  //     String learningBarriers,
  //     ) async {
  //   await Future.delayed(Duration(milliseconds: 10));
  //   _setLoading(true);
  //
  //   try {
  //     final response = await _api.postApiCall(
  //       url:
  //       "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.saveStudentGoals}",
  //       body: {
  //         "studentId": studentId,
  //         "durationDate": durationDate,
  //         "goals": goals,
  //         "intervention": intervention,
  //         "learningBarriers": learningBarriers,
  //       },
  //       token: token,
  //     );
  //
  //     final body = json.decode(response.body);
  //     return body;
  //   } catch (e) {
  //     return {
  //       "responseStatus": false,
  //       "responseMessage": "Exception: $e",
  //     };
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

  Future<Map<String, dynamic>> addWeeklyGoal(
      String studentId,
      String durationDate,
      String goals,
      String intervention,
      String learningBarriers,
      ) async {
    await Future.delayed(const Duration(milliseconds: 10));
    _setLoading(true);

    try {
      final data = await _api.postApiCall(
        url: "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.saveStudentGoals}",
        body: {
          "studentId": studentId,
          "durationDate": durationDate,
          "goals": goals,
          "intervention": intervention,
          "learningBarriers": learningBarriers,
        },
        token: token,
      );

      return data;
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
        token: token,
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

  Future<bool> getAllVideos(context,String id) async {
    await Future.delayed(const Duration(milliseconds: 10));
    _setLoading(true);

    try {
      final response = await _api.getApiCall(
        url: "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getStudentVideos}",
        params: {"studentId": id},
        token: token,
      );

      if (response["responseStatus"] == true && response["data"] is List) {
        _allVideoData = (response["data"] as List)
            .map((e) => StudentAllVideo.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        _setLoading(false);
        return true;
      } else {
        _setError(response["responseMessage"] ?? "Something went wrong");
      }
    } catch (e) {
      if (kDebugMode) {
        print("UnauthorizedException");
      }
      if (e is UnauthorizedException) {
        showSnackBar("Session expired. Please login again.", context);
        Future.delayed(const Duration(milliseconds: 500), () {
          NavigationHelper.pushAndClearStack(context, LoginPage());
        });
        return false;
      }
    } finally {
      _setLoading(false);
    }

    return false;
  }

  // Future<bool> addStudent({
  //   required String firstName,
  //   String? middleName,
  //   required String lastName,
  //   required String mobileNumber,
  //   String? emailId,
  //   required String diagnosis,
  //   required DateTime dob,
  //   required int genderId,
  //   required String pidNumber,
  //   String? pinCode,
  //   String? addressLine1,
  //   String? addressLine2,
  //   required int countryId,
  //   required int stateId,
  //   required int cityId,
  //   required int nationalityId,
  //   required String aadharCardNumber,
  //   String? aadharCardImageName,
  //   String? studentImageName,
  // }) async {
  //   _setLoading(true);
  //
  //   try {
  //     final response = await _api.postApiCall(
  //       url: "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.saveStudent}",
  //       body: {
  //         "instituteId": 22,
  //         "firstName": firstName,
  //         "middleName": middleName ?? "",
  //         "lastName": lastName,
  //         "mobileNumber": mobileNumber,
  //         "emailId": emailId ?? "",
  //         "diagnosis": diagnosis,
  //         "dob": dob.toIso8601String().split("T")[0],
  //         "genderId": genderId,
  //         "pidNumber": pidNumber,
  //         "pinCode": pinCode ?? "",
  //         "addressLine1": addressLine1 ?? "",
  //         "addressLine2": addressLine2 ?? "",
  //         "countryId": countryId,
  //         "stateId": stateId,
  //         "cityId": cityId,
  //         "nationalityId": nationalityId,
  //         "aadharCardNumber": aadharCardNumber,
  //         "aadharCardImage": aadharCardImageName ?? "",
  //         "studentImage": studentImageName ?? "",
  //       },
  //       token: token,
  //     );
  //
  //     final body = json.decode(response.body);
  //     if (response.statusCode == 201 && body["responseStatus"] == true) {
  //       return true;
  //     }
  //     _setError(body["responseMessage"] ?? "Something went wrong");
  //   } catch (e) {
  //     _setError("Exception: $e");
  //   } finally {
  //     _setLoading(false);
  //   }
  //   return false;
  // }
  Future<bool> addStudent({
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
      final data = await _api.postApiCall(
        url: "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.saveStudent}",
        body: {
          "instituteId": 22,
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
        token: token,
      );

      if (data["responseStatus"] == true) {
        return true;
      } else {
        _setError(data["responseMessage"] ?? "Something went wrong");
      }
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
        authToken: token,
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
