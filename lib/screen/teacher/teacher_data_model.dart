

class TeacherListDataModal {
  int? userId;
  String? teacherName;
  String? employeeId;
  String? dateOfBirth;
  String? designation;
  String? mobileNumber;
  String? joiningDate;
  String? emailId;
  int? roleId;
  int? genderId;
  String? gender;
  String? addressLine1;
  String? addressLine2;
  int? cityId;
  String? cityName;
  int? stateId;
  String? stateName;
  String? image;
  String? signature;
  int? countryId;
  String? countryName;
  int? pinCode;
  int? nationalityId;
  String? nationality;
  String? aadharCardImage;
  String? aadharCardNumber;
  String? firstName;
  String? middleName;
  String? lastName;

  TeacherListDataModal(
      {this.userId,
        this.teacherName,
        this.employeeId,
        this.dateOfBirth,
        this.designation,
        this.mobileNumber,
        this.joiningDate,
        this.emailId,
        this.roleId,
        this.genderId,
        this.gender,
        this.addressLine1,
        this.addressLine2,
        this.cityId,
        this.cityName,
        this.stateId,
        this.stateName,
        this.image,
        this.signature,
        this.countryId,
        this.countryName,
        this.pinCode,
        this.nationalityId,
        this.nationality,
        this.aadharCardImage,
        this.aadharCardNumber,
        this.firstName,
        this.middleName,
        this.lastName});

  TeacherListDataModal.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    teacherName = json['teacherName'];
    employeeId = json['employeeId'];
    dateOfBirth = json['dateOfBirth'];
    designation = json['designation'];
    mobileNumber = json['mobileNumber'];
    joiningDate = json['joiningDate'];
    emailId = json['emailId'];
    roleId = json['roleId'];
    genderId = json['genderId'];
    gender = json['gender'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    cityId = json['cityId'];
    cityName = json['cityName'];
    stateId = json['stateId'];
    stateName = json['stateName'];
    image = json['image'];
    signature = json['signature'];
    countryId = json['countryId'];
    countryName = json['countryName'];
    pinCode = json['pinCode'];
    nationalityId = json['nationalityId'];
    nationality = json['nationality'];
    aadharCardImage = json['aadharCardImage'];
    aadharCardNumber = json['aadharCardNumber'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['teacherName'] = teacherName;
    data['employeeId'] = employeeId;
    data['dateOfBirth'] = dateOfBirth;
    data['designation'] = designation;
    data['mobileNumber'] = mobileNumber;
    data['joiningDate'] = joiningDate;
    data['emailId'] = emailId;
    data['roleId'] = roleId;
    data['genderId'] = genderId;
    data['gender'] = gender;
    data['addressLine1'] = addressLine1;
    data['addressLine2'] = addressLine2;
    data['cityId'] = cityId;
    data['cityName'] = cityName;
    data['stateId'] = stateId;
    data['stateName'] = stateName;
    data['image'] = image;
    data['signature'] = signature;
    data['countryId'] = countryId;
    data['countryName'] = countryName;
    data['pinCode'] = pinCode;
    data['nationalityId'] = nationalityId;
    data['nationality'] = nationality;
    data['aadharCardImage'] = aadharCardImage;
    data['aadharCardNumber'] = aadharCardNumber;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    return data;
  }
}

class RoleDataModal {
  int? id;
  String? name;
  int? roleId;
  int? type;

  RoleDataModal({this.id, this.name, this.roleId, this.type});

  RoleDataModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    roleId = json['roleId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['roleId'] = roleId;
    data['type'] = type;
    return data;
  }
}

