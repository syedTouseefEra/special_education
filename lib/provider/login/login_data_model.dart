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
