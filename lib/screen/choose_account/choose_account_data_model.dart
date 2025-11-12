class ChooseAccountDataModel {
  int? organizationId;
  String? organizationName;
  int? instituteId;
  String? instituteName;
  String? organizationTypeName;
  int? organizationTypeId;
  int? userId;
  int? userRoleId;
  String? roleName;
  String? name;
  String? employeeId;
  String? studentId;
  String? profileImage;

  ChooseAccountDataModel(
      {this.organizationId,
        this.organizationName,
        this.instituteId,
        this.instituteName,
        this.organizationTypeName,
        this.organizationTypeId,
        this.userId,
        this.userRoleId,
        this.roleName,
        this.name,
        this.employeeId,
        this.studentId,
        this.profileImage});

  ChooseAccountDataModel.fromJson(Map<String, dynamic> json) {
    organizationId = json['organizationId'];
    organizationName = json['organizationName'];
    instituteId = json['instituteId'];
    instituteName = json['instituteName'];
    organizationTypeName = json['organizationTypeName'];
    organizationTypeId = json['organizationTypeId'];
    userId = json['userId'];
    userRoleId = json['userRoleId'];
    roleName = json['roleName'];
    name = json['name'];
    employeeId = json['employeeId'];
    studentId = json['studentId'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['organizationId'] = organizationId;
    data['organizationName'] = organizationName;
    data['instituteId'] = instituteId;
    data['instituteName'] = instituteName;
    data['organizationTypeName'] = organizationTypeName;
    data['organizationTypeId'] = organizationTypeId;
    data['userId'] = userId;
    data['userRoleId'] = userRoleId;
    data['roleName'] = roleName;
    data['name'] = name;
    data['employeeId'] = employeeId;
    data['studentId'] = studentId;
    data['profileImage'] = profileImage;
    return data;
  }
}
