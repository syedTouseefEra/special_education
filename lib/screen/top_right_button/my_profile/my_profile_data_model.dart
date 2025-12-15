
class MyProfileDataModel {
  int? teacherId;
  String? teacherName;
  String? employeeId;
  String? mobileNumber;
  String? emailId;
  String? registrationNumber;
  String? dateOfBirth;
  String? gender;
  int? pinCode;
  String? addressLine1;
  String? addressLine2;
  int? countryId;
  String? countryName;
  int? stateId;
  String? state;
  int? cityId;
  String? designation;
  String? joiningDate;
  String? cityName;
  int? nationalityId;
  String? nationality;
  String? adharCardImage;
  String? adharCardNumber;
  String? image;
  String? signature;
  String? firstName;
  String? middleName;
  String? lastName;

  MyProfileDataModel(
      {this.teacherId,
        this.teacherName,
        this.employeeId,
        this.mobileNumber,
        this.emailId,
        this.registrationNumber,
        this.dateOfBirth,
        this.gender,
        this.pinCode,
        this.addressLine1,
        this.addressLine2,
        this.countryId,
        this.countryName,
        this.stateId,
        this.state,
        this.cityId,
        this.designation,
        this.joiningDate,
        this.cityName,
        this.nationalityId,
        this.nationality,
        this.adharCardImage,
        this.adharCardNumber,
        this.image,
        this.signature,
        this.firstName,
        this.middleName,
        this.lastName});

  MyProfileDataModel.fromJson(Map<String, dynamic> json) {
    teacherId = json['teacherId'];
    teacherName = json['teacherName'];
    employeeId = json['employeeId'];
    mobileNumber = json['mobileNumber'];
    emailId = json['emailId'];
    registrationNumber = json['registrationNumber'];
    dateOfBirth = json['dateOfBirth'];
    gender = json['gender'];
    pinCode = json['pinCode'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    countryId = json['countryId'];
    countryName = json['countryName'];
    stateId = json['stateId'];
    state = json['state'];
    cityId = json['cityId'];
    designation = json['designation'];
    joiningDate = json['joiningDate'];
    cityName = json['cityName'];
    nationalityId = json['nationalityId'];
    nationality = json['nationality'];
    adharCardImage = json['adharCardImage'];
    adharCardNumber = json['adharCardNumber'];
    image = json['image'];
    signature = json['signature'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['teacherId'] = teacherId;
    data['teacherName'] = teacherName;
    data['employeeId'] = employeeId;
    data['mobileNumber'] = mobileNumber;
    data['emailId'] = emailId;
    data['registrationNumber'] = registrationNumber;
    data['dateOfBirth'] = dateOfBirth;
    data['gender'] = gender;
    data['pinCode'] = pinCode;
    data['addressLine1'] = addressLine1;
    data['addressLine2'] = addressLine2;
    data['countryId'] = countryId;
    data['countryName'] = countryName;
    data['stateId'] = stateId;
    data['state'] = state;
    data['cityId'] = cityId;
    data['designation'] = designation;
    data['joiningDate'] = joiningDate;
    data['cityName'] = cityName;
    data['nationalityId'] = nationalityId;
    data['nationality'] = nationality;
    data['adharCardImage'] = adharCardImage;
    data['adharCardNumber'] = adharCardNumber;
    data['image'] = image;
    data['signature'] = signature;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    return data;
  }
}
