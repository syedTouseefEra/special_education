

class TrimesterReportDataModal {
  int? studentId;
  String? image;
  int? genderId;
  String? gender;
  String? studentName;
  String? diagnosis;
  int? pidNumber;
  String? dateOfAdmission;
  String? age;
  List<Trimester>? trimester;

  TrimesterReportDataModal(
      {this.studentId,
        this.image,
        this.genderId,
        this.gender,
        this.studentName,
        this.diagnosis,
        this.pidNumber,
        this.dateOfAdmission,
        this.age,
        this.trimester});

  TrimesterReportDataModal.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    image = json['image'];
    genderId = json['genderId'];
    gender = json['gender'];
    studentName = json['studentName'];
    diagnosis = json['diagnosis'];
    pidNumber = json['pidNumber'];
    dateOfAdmission = json['dateOfAdmission'];
    age = json['age'];
    if (json['trimester'] != null) {
      trimester = <Trimester>[];
      json['trimester'].forEach((v) {
        trimester!.add(Trimester.fromJson(v));
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
    data['dateOfAdmission'] = dateOfAdmission;
    data['age'] = age;
    if (trimester != null) {
      data['trimester'] = trimester!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Trimester {
  int? trimesterId;
  String? reportStatus;
  String? durationDate;
  String? endDate;
  String? status;

  Trimester(
      {this.trimesterId,
        this.reportStatus,
        this.durationDate,
        this.endDate,
        this.status});

  Trimester.fromJson(Map<String, dynamic> json) {
    trimesterId = json['trimesterId'];
    reportStatus = json['reportStatus'];
    durationDate = json['durationDate'];
    endDate = json['endDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trimesterId'] = trimesterId;
    data['reportStatus'] = reportStatus;
    data['durationDate'] = durationDate;
    data['endDate'] = endDate;
    data['status'] = status;
    return data;
  }
}


