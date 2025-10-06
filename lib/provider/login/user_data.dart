import 'package:get_storage/get_storage.dart';
import 'package:special_education/provider/login/login_data_model.dart';

class UserData {
  final GetStorage _userBox = GetStorage('user');
  final GetStorage _registeredBox = GetStorage('registered');

  /// Save user data to storage
  Future<void> addUserData(LoginDataModel val) async {
    await _userBox.write('userData', val.toJson());
  }

  /// Save registered data to storage
  Future<void> addRegisteredData(Map<String, dynamic> val) async {
    await _registeredBox.write('registered', val);
  }

  /// Get user data safely
  LoginDataModel? get getUserData {
    final rawData = _userBox.read('userData');
    if (rawData == null || rawData is! Map) {
      return null;
    }
    final data = Map<String, dynamic>.from(rawData);
    return LoginDataModel.fromJson(data);
  }

  /// Remove user data
  Future<void> removeUserData() async {
    await _userBox.remove('userData');
  }
}
