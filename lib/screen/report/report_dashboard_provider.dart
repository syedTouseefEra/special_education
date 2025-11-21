


import 'package:flutter/cupertino.dart';
import 'package:special_education/api_service/api_calling_types.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/screen/dashboard/dashboard_data_modal.dart';
import 'package:special_education/screen/login/login_view.dart';
import 'package:special_education/screen/report/trimester_report/generate_trimester_report/learning_area_report_data_modal.dart';
import 'package:special_education/screen/report/trimester_report/trimester_report_data_model.dart';
import 'package:special_education/user_data/user_data.dart';
import 'package:special_education/utils/exception_handle.dart';
import 'package:special_education/utils/navigation_utils.dart';

class ReportDashboardProvider extends ChangeNotifier{

  bool _isLoading = false;
  String? _error;
  String _searchQuery = "";

  bool get isLoading => _isLoading;
  String? get error => _error;

  String trimesterId = '';
  String studentId = '';
  String startDate = '';
  String endDate = '';

  final _api = ApiCallingTypes(baseUrl: ApiServiceUrl.apiBaseUrl);

  List<StudentListDataModal>? _studentData;
  List<StudentListDataModal>? _filteredStudentData;

  List<StudentListDataModal>? get studentData {
    if (_searchQuery.isEmpty) {
      return _studentData;
    } else {
      return _filteredStudentData;
    }
  }

  List<TrimesterReportDataModal>? _trimesterReportData;
  List<TrimesterReportDataModal>? get trimesterReportData {
    return _trimesterReportData;
  }

  List<LearningAreaReportDataModal>? _learningAreasReportData;
  List<LearningAreaReportDataModal>? get learningAreasData {
    return _learningAreasReportData;
  }

  final UserData userData = UserData();
  late var token = userData.getUserData.token;
  late var instituteId = userData.getUserData.instituteId ?? "0";

  Future<bool> fetchReportStudentList(dynamic context) async {
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

  Future<bool> getTrimesterReportData(dynamic context,String studentId) async {
    await Future.delayed(const Duration(milliseconds: 10));
    _setLoading(true);
    try {

      final response = await _api.getApiCall(
        url:
        "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getTrimesterReport}",
        params: {"studentId": studentId},
        token: token,
      );

      if (response["responseStatus"] == true && response["data"] is List) {
        _trimesterReportData = (response["data"] as List)
            .map((e) => TrimesterReportDataModal.fromJson(
          Map<String, dynamic>.from(e),
        ))
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

  Future<bool> getLearningAreasData(dynamic context,String studentId) async {
    await Future.delayed(const Duration(milliseconds: 10));
    _setLoading(true);
    try {

      final response = await _api.getApiCall(
        url:
        "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.learningAreas}",
        params: {"studentId": studentId},
        token: token,
      );

      if (response["responseStatus"] == true && response["data"] is List) {
        _learningAreasReportData = (response["data"] as List)
            .map((e) => LearningAreaReportDataModal.fromJson(
          Map<String, dynamic>.from(e),
        ))
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

  Future<bool> saveTrimesterReport(dynamic context, String learningTextData) async {
    await Future.delayed(const Duration(milliseconds: 10));
    _setLoading(true);
    try {
      final response = await _api.postApiCall(
        url: "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.saveGenerateReport}",
        body: {
          "trimesterId": trimesterId,
          "studentId": studentId,
          "startDate": startDate,
          "endDate": endDate,
          "learningText": learningTextData,
        },
        token: token,
      );

      if (response["responseStatus"] == true && response["data"] is List) {
        showSnackBar(response["responseMessage"] , context);
        NavigationHelper.pop(context);
        return true;
      } else {
        showSnackBar(context, response["responseMessage"] ?? "Invalid data received");
      }
    } catch (e) {
      if (e is UnauthorizedException) {
        unauthorizedUser(context);
        return false;
      }
    } finally {
      _setLoading(false);
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

}