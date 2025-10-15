import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:special_education/api_service/api_calling_types.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/screen/dashboard/dashboard_data_modal.dart';

class DashboardProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<WeekGoalDataModal>? _weekData;
  List<LongGoalDataModal>? _longGoalData;
  List<StudentListDataModal>? _studentData;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<WeekGoalDataModal>? get weekData => _weekData;
  List<LongGoalDataModal>? get longGoalData => _longGoalData;
  List<StudentListDataModal>? get studentData => _studentData;

  final ApiCallingTypes _api = ApiCallingTypes(baseUrl: ApiServiceUrl.apiBaseUrl);
  final GetStorage _userBox = GetStorage('user');


  Future<bool> getDashboardWeekData() async {
    await Future.delayed(Duration(milliseconds: 10));
    return _getDashboardData<List<WeekGoalDataModal>>(
      cacheKey: 'weekGoalData',
      url: "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getDashboardWeek}",
      params: {"instituteId": "22"},
      onSuccess: (list) => _weekData =
          list.map((e) => WeekGoalDataModal.fromJson(Map<String, dynamic>.from(e))).toList(),
    );
  }

  void loadCachedWeekGoalData() {
    _loadCachedList<WeekGoalDataModal>(
      'weekGoalData',
          (json) => WeekGoalDataModal.fromJson(json),
          (list) => _weekData = list,
    );
  }

  /// ============ LONG GOAL DATA ============
  Future<bool> getDashboardLongGoalData() async {
    await Future.delayed(Duration(milliseconds: 10));
    return _getDashboardData<List<LongGoalDataModal>>(
      cacheKey: 'longGoalData',
      url: "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getDashboardLongTermGoal}",
      params: {"instituteId": "22"},
      onSuccess: (list) => _longGoalData =
          list.map((e) => LongGoalDataModal.fromJson(Map<String, dynamic>.from(e))).toList(),
    );
  }

  void loadCachedLongGoalData() {
    _loadCachedList<LongGoalDataModal>(
      'longGoalData',
          (json) => LongGoalDataModal.fromJson(json),
          (list) => _longGoalData = list,
    );
  }

  Future<bool> getDashboardStudentListData() async {
    await Future.delayed(Duration(milliseconds: 10));
    return _getDashboardData<List<StudentListDataModal>>(
      cacheKey: 'studentData',
      url: "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getStudentByInstituteId}",
      params: {"instituteId": "22"},
      onSuccess: (list) => _studentData =
          list.map((e) => StudentListDataModal.fromJson(Map<String, dynamic>.from(e))).toList(),
    );
  }

  void loadCachedStudentListData() {
    _loadCachedList<StudentListDataModal>(
      'studentData',
          (json) => StudentListDataModal.fromJson(json),
          (list) => _studentData = list,
    );
  }

  Future<bool> _getDashboardData<T>({
    required String cacheKey,
    required String url,
    required Map<String, String> params,
    required Function(List<dynamic>) onSuccess,
  }) async {
    await Future.delayed(Duration(milliseconds: 10));
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final savedUser = _userBox.read('userData');
      if (savedUser == null) {
        _error = "No user data found";
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final response = await _api.getApiCall(url: url, params: params, token: ApiServiceUrl.token);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["responseStatus"] == true && data["data"] is List) {
          final List<dynamic> list = data["data"];
          onSuccess(list);
          await _userBox.write(cacheKey, list);
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _error = data["responseMessage"] ?? "Failed to fetch data";
        }
      } else {
        _error = "Server error: ${response.statusCode}";
      }
    } catch (e) {
      _error = "Exception: $e";
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// ============ COMMON CACHING METHOD ============
  void _loadCachedList<T>(
      String cacheKey,
      T Function(Map<String, dynamic>) fromJson,
      void Function(List<T>) setList,
      ) {
    final saved = _userBox.read(cacheKey);
    if (saved != null && saved is List) {
      setList(saved.map((e) => fromJson(Map<String, dynamic>.from(e))).toList());
      notifyListeners();
    }
  }
}
