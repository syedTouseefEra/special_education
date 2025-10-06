
class WeekGoalDataModal {
  int? weekCount;
  int? totalStudent;
  int? completedStudentCount;
  double? completionPercentage;

  WeekGoalDataModal(
      {this.weekCount,
        this.totalStudent,
        this.completedStudentCount,
        this.completionPercentage});

  WeekGoalDataModal.fromJson(Map<String, dynamic> json) {
    weekCount = json['weekCount'];
    totalStudent = json['totalStudent'];
    completedStudentCount = json['completedStudentCount'];
    completionPercentage = json['completionPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['weekCount'] = weekCount;
    data['totalStudent'] = totalStudent;
    data['completedStudentCount'] = completedStudentCount;
    data['completionPercentage'] = completionPercentage;
    return data;
  }
}


class LongGoalDataModal {
  int? goalCount;
  int? totalStudent;
  int? completedStudentCount;
  double? completionPercentage;

  LongGoalDataModal(
      {this.goalCount,
        this.totalStudent,
        this.completedStudentCount,
        this.completionPercentage});

  LongGoalDataModal.fromJson(Map<String, dynamic> json) {
    goalCount = json['goalCount'];
    totalStudent = json['totalStudent'];
    completedStudentCount = json['completedStudentCount'];
    completionPercentage = json['completionPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['goalCount'] = goalCount;
    data['totalStudent'] = totalStudent;
    data['completedStudentCount'] = completedStudentCount;
    data['completionPercentage'] = completionPercentage;
    return data;
  }
}

class StudentListDataModal {
  int? id;
  String? studentName;
  String? studentImage;
  int? pidNumber;
  String? diagnosis;
  int? genderId;
  String? gender;

  StudentListDataModal(
      {this.id,
        this.studentName,
        this.studentImage,
        this.pidNumber,
        this.diagnosis,
        this.genderId,
        this.gender});

  StudentListDataModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentName = json['studentName'];
    studentImage = json['studentImage'];
    pidNumber = json['pidNumber'];
    diagnosis = json['diagnosis'];
    genderId = json['genderId'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['studentName'] = studentName;
    data['studentImage'] = studentImage;
    data['pidNumber'] = pidNumber;
    data['diagnosis'] = diagnosis;
    data['genderId'] = genderId;
    data['gender'] = gender;
    return data;
  }
}
