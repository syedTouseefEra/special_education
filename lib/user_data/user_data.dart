
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:special_education/screen/login/login_data_model.dart';

final userDataProvider = Provider<UserData>(
  create: (context) => UserData(),
);

class UserData {
  final GetStorage userData = GetStorage('user');
  final GetStorage registeredData = GetStorage('registered');

  Future<void> addUserData(dynamic val) async {
    await userData.write('userData', val);
  }

  Future<void> addRegisteredData(Map val) async {
    await registeredData.write('registered', val);
  }

  UserInstituteDataModal get getUserData {
    final rawData = userData.read('userData');
    if (rawData == null || rawData is! Map) {
      return UserInstituteDataModal();
    }
    final data = Map<String, dynamic>.from(rawData);
    return UserInstituteDataModal.fromJson(data);
  }

  Future<void> removeUserData() async {
    await userData.remove('userData');
  }
}
