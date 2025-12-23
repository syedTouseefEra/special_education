

class WeeklyReportDataModel {
  int? studentId;
  String? image;
  int? genderId;
  String? gender;
  String? studentName;
  String? diagnosis;
  int? pidNumber;
  String? dateOfAdmission;
  String? age;
  List<WeeklyGoal>? weeklyGoal;

  WeeklyReportDataModel(
      {this.studentId,
        this.image,
        this.genderId,
        this.gender,
        this.studentName,
        this.diagnosis,
        this.pidNumber,
        this.dateOfAdmission,
        this.age,
        this.weeklyGoal});

  WeeklyReportDataModel.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    image = json['image'];
    genderId = json['genderId'];
    gender = json['gender'];
    studentName = json['studentName'];
    diagnosis = json['diagnosis'];
    pidNumber = json['pidNumber'];
    dateOfAdmission = json['dateOfAdmission'];
    age = json['age'];
    if (json['weeklyGoal'] != null) {
      weeklyGoal = <WeeklyGoal>[];
      json['weeklyGoal'].forEach((v) {
        weeklyGoal!.add(WeeklyGoal.fromJson(v));
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
    if (weeklyGoal != null) {
      data['weeklyGoal'] = weeklyGoal!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WeeklyGoal {
  int? id;
  String? durationDate;
  String? goals;
  String? intervention;
  String? learningBarriers;
  String? learningOutCome;
  String? remarks;
  int? goalStatus;
  int? weekCount;
  List<VideoList>? videoList;

  WeeklyGoal(
      {this.id,
        this.durationDate,
        this.goals,
        this.intervention,
        this.learningBarriers,
        this.learningOutCome,
        this.remarks,
        this.goalStatus,
        this.weekCount,
        this.videoList});

  WeeklyGoal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    durationDate = json['durationDate'];
    goals = json['goals'];
    intervention = json['intervention'];
    learningBarriers = json['learningBarriers'];
    learningOutCome = json['learningOutCome'];
    remarks = json['remarks'];
    goalStatus = json['goalStatus'];
    weekCount = json['weekCount'];
    if (json['videoList'] != null) {
      videoList = <VideoList>[];
      json['videoList'].forEach((v) {
        videoList!.add(VideoList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['durationDate'] = durationDate;
    data['goals'] = goals;
    data['intervention'] = intervention;
    data['learningBarriers'] = learningBarriers;
    data['learningOutCome'] = learningOutCome;
    data['remarks'] = remarks;
    data['goalStatus'] = goalStatus;
    data['weekCount'] = weekCount;
    if (videoList != null) {
      data['videoList'] = videoList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VideoList {
  int? id;
  String? videoName;
  String? createdDate;

  VideoList({this.id, this.videoName, this.createdDate});

  VideoList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoName = json['videoName'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['videoName'] = videoName;
    data['createdDate'] = createdDate;
    return data;
  }
}


