
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:special_education/screen/login/login_data_model.dart';


final userDataProvider = Provider<UserData>(
  create: (context) => UserData(),
);

class UserData {
  final GetStorage _userStorage = GetStorage('user');
  final GetStorage _registeredStorage = GetStorage('registered');

  Future<void> addUserData(Map<String, dynamic> val) async {
    await _userStorage.write('userData', val);
    await setSession(true);
  }

  Future<void> addRegisteredData(Map<String, dynamic> val) async {
    await _registeredStorage.write('registered', val);
  }

  UserInstituteDataModal get getUserData {
    final rawData = _userStorage.read('userData');
    if (rawData == null || rawData is! Map) {
      return UserInstituteDataModal();
    }
    final data = Map<String, dynamic>.from(rawData);
    return UserInstituteDataModal.fromJson(data);
  }

  Future<void> removeUserData() async {
    await _userStorage.remove('userData');
    await setSession(false);
  }

  Future<void> setSession(bool isLoggedIn) async {
    await _userStorage.write('isLoggedIn', isLoggedIn);
  }

  bool get isLoggedIn {
    return _userStorage.read('isLoggedIn') ?? false;
  }
}
