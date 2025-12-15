class ViewPDFReportDataModel {
  int? studentId;
  String? image;
  int? genderId;
  String? gender;
  String? studentName;
  String? diagnosis;
  int? pidNumber;
  String? dob;
  String? dateOfAdmission;
  String? age;
  String? addressLine1;
  String? addressLine2;
  String? instituteName;
  String? instituteAdddress;
  String? programStartDate;
  String? timeFrame;
  String? motherName;
  String? fatherName;
  List<SkillQuality>? skillQuality;
  List<TrimesterPerformance>? trimesterPerformance;

  ViewPDFReportDataModel(
      {this.studentId,
        this.image,
        this.genderId,
        this.gender,
        this.studentName,
        this.diagnosis,
        this.pidNumber,
        this.dob,
        this.dateOfAdmission,
        this.age,
        this.addressLine1,
        this.addressLine2,
        this.instituteName,
        this.instituteAdddress,
        this.programStartDate,
        this.timeFrame,
        this.motherName,
        this.fatherName,
        this.skillQuality,
        this.trimesterPerformance});

  ViewPDFReportDataModel.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    image = json['image'];
    genderId = json['genderId'];
    gender = json['gender'];
    studentName = json['studentName'];
    diagnosis = json['diagnosis'];
    pidNumber = json['pidNumber'];
    dob = json['dob'];
    dateOfAdmission = json['dateOfAdmission'];
    age = json['age'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    instituteName = json['instituteName'];
    instituteAdddress = json['instituteAdddress'];
    programStartDate = json['programStartDate'];
    timeFrame = json['timeFrame'];
    motherName = json['motherName'];
    fatherName = json['fatherName'];
    if (json['skillQuality'] != null) {
      skillQuality = <SkillQuality>[];
      json['skillQuality'].forEach((v) {
        skillQuality!.add(SkillQuality.fromJson(v));
      });
    }
    if (json['trimesterPerformance'] != null) {
      trimesterPerformance = <TrimesterPerformance>[];
      json['trimesterPerformance'].forEach((v) {
        trimesterPerformance!.add(TrimesterPerformance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['studentId'] = studentId;
    data['image'] = image;
    data['genderId'] = genderId;
    data['gender'] = gender;
    data['studentName'] = studentName;
    data['diagnosis'] = diagnosis;
    data['pidNumber'] = pidNumber;
    data['dob'] = dob;
    data['dateOfAdmission'] = dateOfAdmission;
    data['age'] = age;
    data['addressLine1'] = addressLine1;
    data['addressLine2'] = addressLine2;
    data['instituteName'] = instituteName;
    data['instituteAdddress'] = instituteAdddress;
    data['programStartDate'] = programStartDate;
    data['timeFrame'] = timeFrame;
    if (skillQuality != null) {
      data['skillQuality'] = skillQuality!.map((v) => v.toJson()).toList();
    }
    if (trimesterPerformance != null) {
      data['trimesterPerformance'] =
          trimesterPerformance!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SkillQuality {
  int? qualityId;
  String? name;
  String? remarks;
  int? star;
  int? selectedStar;
  List<Quality>? quality;

  SkillQuality(
      {this.qualityId,
        this.name,
        this.remarks,
        this.star,
        this.selectedStar,
        this.quality});

  SkillQuality.fromJson(Map<String, dynamic> json) {
    qualityId = json['qualityId'];
    name = json['name'];
    remarks = json['remarks'];
    star = json['star'];
    selectedStar = json['selectedStar'];
    if (json['quality'] != null) {
      quality = <Quality>[];
      json['quality'].forEach((v) {
        quality!.add(Quality.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qualityId'] = qualityId;
    data['name'] = name;
    data['remarks'] = remarks;
    data['star'] = star;
    data['selectedStar'] = selectedStar;
    if (quality != null) {
      data['quality'] = quality!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Quality {
  int? qualityParentId;
  int? ratingId;
  String? name;

  Quality({this.qualityParentId, this.ratingId, this.name});

  Quality.fromJson(Map<String, dynamic> json) {
    qualityParentId = json['qualityParentId'];
    ratingId = json['ratingId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qualityParentId'] = qualityParentId;
    data['ratingId'] = ratingId;
    data['name'] = name;
    return data;
  }
}

class TrimesterPerformance {
  int? id;
  String? name;
  int? ratingId;
  String? remarks;

  TrimesterPerformance({this.id, this.name, this.ratingId, this.remarks});

  TrimesterPerformance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    ratingId = json['ratingId'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['ratingId'] = ratingId;
    data['remarks'] = remarks;
    return data;
  }
}
