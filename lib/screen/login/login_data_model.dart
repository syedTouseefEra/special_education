class LoginDataModel {
  final int userId;
  final String userName;
  final String name;
  final double latitude;
  final int profileCount;
  final double longitude;
  final bool isMobileVerify;
  final bool isEmailVerify;
  final String token;

  const LoginDataModel({
    required this.userId,
    required this.userName,
    required this.name,
    required this.latitude,
    required this.profileCount,
    required this.longitude,
    required this.isMobileVerify,
    required this.isEmailVerify,
    required this.token,
  });

  factory LoginDataModel.fromJson(Map<String, dynamic> json) {
    return LoginDataModel(
      userId: json['userId'] is int ? json['userId'] as int : 0,
      userName: json['userName'] ?? '',
      name: json['name'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      profileCount: json['profileCount'] is int ? json['profileCount'] as int : 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      isMobileVerify: json['isMobileVerify'] ?? false,
      isEmailVerify: json['isEmailVerify'] ?? false,
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'name': name,
      'latitude': latitude,
      'profileCount': profileCount,
      'longitude': longitude,
      'isMobileVerify': isMobileVerify,
      'isEmailVerify': isEmailVerify,
      'token': token,
    };
  }
}
class UserInstituteDataModal {
  int? userId;
  String? userName;
  String? name;
  String? mobileNo;
  String? email;
  double? latitude;
  double? longitude;
  int? userRoleId;
  String? roleName;
  bool? isMobileVerify;
  bool? isEmailVerify;
  int? organizationId;
  int? instituteId;
  String? instituteName;
  Null? isApproved;
  Null? isBlock;
  String? profileImage;
  String? token;

  UserInstituteDataModal(
      {this.userId,
        this.userName,
        this.name,
        this.mobileNo,
        this.email,
        this.latitude,
        this.longitude,
        this.userRoleId,
        this.roleName,
        this.isMobileVerify,
        this.isEmailVerify,
        this.organizationId,
        this.instituteId,
        this.instituteName,
        this.isApproved,
        this.isBlock,
        this.profileImage,
        this.token});

  UserInstituteDataModal.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    name = json['name'];
    mobileNo = json['mobileNo'];
    email = json['email'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    userRoleId = json['userRoleId'];
    roleName = json['roleName'];
    isMobileVerify = json['isMobileVerify'];
    isEmailVerify = json['isEmailVerify'];
    organizationId = json['organizationId'];
    instituteId = json['instituteId'];
    instituteName = json['instituteName'];
    isApproved = json['isApproved'];
    isBlock = json['isBlock'];
    profileImage = json['profileImage'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['userName'] = userName;
    data['name'] = name;
    data['mobileNo'] = mobileNo;
    data['email'] = email;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['userRoleId'] = userRoleId;
    data['roleName'] = roleName;
    data['isMobileVerify'] = isMobileVerify;
    data['isEmailVerify'] = isEmailVerify;
    data['organizationId'] = organizationId;
    data['instituteId'] = instituteId;
    data['instituteName'] = instituteName;
    data['isApproved'] = isApproved;
    data['isBlock'] = isBlock;
    data['profileImage'] = profileImage;
    data['token'] = token;
    return data;
  }
}
