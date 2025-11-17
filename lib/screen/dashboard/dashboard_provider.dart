
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:special_education/api_service/api_calling_types.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/screen/dashboard/dashboard_data_modal.dart';
import 'package:special_education/screen/login/login_view.dart';
import 'package:special_education/user_data/user_data.dart';
import 'package:special_education/utils/exception_handle.dart';
import 'package:special_education/utils/navigation_utils.dart';

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

  final ApiCallingTypes _api =
  ApiCallingTypes(baseUrl: ApiServiceUrl.apiBaseUrl);
  final UserData _userData = UserData();

  Future<void> fetchDashboardData(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    await getDashboardWeekData(context);
    await getDashboardLongGoalData(context);
    await getDashboardStudentListData(context);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getDashboardWeekData(BuildContext context) async {
    final instituteId = _userData.getUserData.instituteId ?? "0";

    await _getDashboardData(
      context,
      cacheKey: 'weekGoalData',
      url:
      "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getDashboardWeek}",
      params: {"instituteId": instituteId.toString()},
      onSuccess: (list) {
        _weekData = list
            .map((e) => WeekGoalDataModal.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        debugPrint("✅ Week data loaded: ${_weekData?.length}");
      },
    );
  }

  Future<void> getDashboardLongGoalData(BuildContext context) async {
    final instituteId = _userData.getUserData.instituteId ?? "0";

    await _getDashboardData(
      context,
      cacheKey: 'longGoalData',
      url:
      "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getDashboardLongTermGoal}",
      params: {"instituteId": instituteId.toString()},
      onSuccess: (list) {
        _longGoalData = list
            .map((e) => LongGoalDataModal.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        debugPrint("✅ Long goal data loaded: ${_longGoalData?.length}");
      },
    );
  }

  Future<void> getDashboardStudentListData(BuildContext context) async {
    final instituteId = _userData.getUserData.instituteId ?? "22";

    await _getDashboardData(
      context,
      cacheKey: 'studentData',
      url:
      "${ApiServiceUrl.hamaareSitaareApiBaseUrl}${ApiServiceUrl.getStudentByInstituteId}",
      params: {"instituteId": instituteId.toString()},
      onSuccess: (list) {
        _studentData = list
            .map(
                (e) => StudentListDataModal.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        debugPrint("✅ Student data loaded: ${_studentData?.length}");
      },
    );
  }

  Future<bool> _getDashboardData(
      BuildContext context, {
        required String cacheKey,
        required String url,
        required Map<String, String> params,
        required Function(List<dynamic>) onSuccess,
      }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final savedUser = _userData.getUserData;
      final token = savedUser.token ?? '';
      final data = await _api.getApiCall(url: url, params: params, token: token);

      if (data["responseStatus"] == true && data["data"] is List) {
        final List<dynamic> list = data["data"];
        onSuccess(list);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = data["responseMessage"] ?? "Failed to fetch $cacheKey";
        debugPrint("⚠️ API Error ($cacheKey): $_error");
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
    _isLoading = false;
    notifyListeners();
    return false;
  }

}
