

class UpdateStudentProfileDataModel {
  int? id;
  int? instituteId;
  String? instituteName;
  String? firstName;
  String? middleName;
  String? lastName;
  String? mobileNumber;
  String? emailId;
  String? diagnosis;
  String? dob;
  int? genderId;
  String? genderName;
  int? pidNumber;
  String? pinCode;
  String? addressLine1;
  String? addressLine2;
  int? countryId;
  String? countryName;
  int? stateId;
  String? stateName;
  int? cityId;
  String? cityName;
  int? nationalityId;
  String? nationalityName;
  String? aadharCardNumber;
  String? aadharCardImage;
  String? studentImage;

  UpdateStudentProfileDataModel(
      {this.id,
        this.instituteId,
        this.instituteName,
        this.firstName,
        this.middleName,
        this.lastName,
        this.mobileNumber,
        this.emailId,
        this.diagnosis,
        this.dob,
        this.genderId,
        this.genderName,
        this.pidNumber,
        this.pinCode,
        this.addressLine1,
        this.addressLine2,
        this.countryId,
        this.countryName,
        this.stateId,
        this.stateName,
        this.cityId,
        this.cityName,
        this.nationalityId,
        this.nationalityName,
        this.aadharCardNumber,
        this.aadharCardImage,
        this.studentImage});

  UpdateStudentProfileDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    instituteId = json['instituteId'];
    instituteName = json['instituteName'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    mobileNumber = json['mobileNumber'];
    emailId = json['emailId'];
    diagnosis = json['diagnosis'];
    dob = json['dob'];
    genderId = json['genderId'];
    genderName = json['genderName'];
    pidNumber = json['pidNumber'];
    pinCode = json['pinCode'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    countryId = json['countryId'];
    countryName = json['countryName'];
    stateId = json['stateId'];
    stateName = json['stateName'];
    cityId = json['cityId'];
    cityName = json['cityName'];
    nationalityId = json['nationalityId'];
    nationalityName = json['nationalityName'];
    aadharCardNumber = json['aadharCardNumber'];
    aadharCardImage = json['aadharCardImage'];
    studentImage = json['studentImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['instituteId'] = instituteId;
    data['instituteName'] = instituteName;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['mobileNumber'] = mobileNumber;
    data['emailId'] = emailId;
    data['diagnosis'] = diagnosis;
    data['dob'] = dob;
    data['genderId'] = genderId;
    data['genderName'] = genderName;
    data['pidNumber'] = pidNumber;
    data['pinCode'] = pinCode;
    data['addressLine1'] = addressLine1;
    data['addressLine2'] = addressLine2;
    data['countryId'] = countryId;
    data['countryName'] = countryName;
    data['stateId'] = stateId;
    data['stateName'] = stateName;
    data['cityId'] = cityId;
    data['cityName'] = cityName;
    data['nationalityId'] = nationalityId;
    data['nationalityName'] = nationalityName;
    data['aadharCardNumber'] = aadharCardNumber;
    data['aadharCardImage'] = aadharCardImage;
    data['studentImage'] = studentImage;
    return data;
  }
}


class UpdateStudentPsychoSkillDataModel {
  int? skillId;
  String? name;
  List<SkillQuality>? skillQuality;

  UpdateStudentPsychoSkillDataModel(
      {this.skillId, this.name, this.skillQuality});

  UpdateStudentPsychoSkillDataModel.fromJson(Map<String, dynamic> json) {
    skillId = json['skillId'];
    name = json['name'];
    if (json['skillQuality'] != null) {
      skillQuality = <SkillQuality>[];
      json['skillQuality'].forEach((v) {
        skillQuality!.add(SkillQuality.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skillId'] = skillId;
    data['name'] = name;
    if (skillQuality != null) {
      data['skillQuality'] = skillQuality!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SkillQuality {
  int? studentSkillId;
  int? qualityId;
  String? name;
  int? ratingId;
  List<SkillQualityParent>? skillQualityParent;

  SkillQuality(
      {this.studentSkillId,
        this.qualityId,
        this.name,
        this.ratingId,
        this.skillQualityParent});

  SkillQuality.fromJson(Map<String, dynamic> json) {
    studentSkillId = json['studentSkillId'];
    qualityId = json['qualityId'];
    name = json['name'];
    ratingId = json['ratingId'];
    if (json['skillQualityParent'] != null) {
      skillQualityParent = <SkillQualityParent>[];
      json['skillQualityParent'].forEach((v) {
        skillQualityParent!.add(SkillQualityParent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['studentSkillId'] = studentSkillId;
    data['qualityId'] = qualityId;
    data['name'] = name;
    data['ratingId'] = ratingId;
    if (skillQualityParent != null) {
      data['skillQualityParent'] =
          skillQualityParent!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SkillQualityParent {
  int? studentSkillId;
  int? qualityId;
  int? qualityParentId;
  String? name;
  int? ratingId;

  SkillQualityParent(
      {this.studentSkillId,
        this.qualityId,
        this.qualityParentId,
        this.name,
        this.ratingId});

  SkillQualityParent.fromJson(Map<String, dynamic> json) {
    studentSkillId = json['studentSkillId'];
    qualityId = json['qualityId'];
    qualityParentId = json['qualityParentId'];
    name = json['name'];
    ratingId = json['ratingId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['studentSkillId'] = studentSkillId;
    data['qualityId'] = qualityId;
    data['qualityParentId'] = qualityParentId;
    data['name'] = name;
    data['ratingId'] = ratingId;
    return data;
  }
}
