

class WeeklyPdfReportDataModel {
  int? studentId;
  String? image;
  int? genderId;
  String? gender;
  String? firstName;
  String? lastName;
  String? middleName;
  String? diagnosis;
  int? pidNumber;
  String? dob;
  String? dateOfAdmission;
  String? age;
  String? mobileNumber;
  String? aadharCardNumber;
  String? emailId;
  String? aadharCardImage;
  List<SkillList>? skillList;
  List<LearningObjective>? learningObjective;

  WeeklyPdfReportDataModel(
      {this.studentId,
        this.image,
        this.genderId,
        this.gender,
        this.firstName,
        this.lastName,
        this.middleName,
        this.diagnosis,
        this.pidNumber,
        this.dob,
        this.dateOfAdmission,
        this.age,
        this.mobileNumber,
        this.aadharCardNumber,
        this.emailId,
        this.aadharCardImage,
        this.skillList,
        this.learningObjective});

  WeeklyPdfReportDataModel.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    image = json['image'];
    genderId = json['genderId'];
    gender = json['gender'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    middleName = json['middleName'];
    diagnosis = json['diagnosis'];
    pidNumber = json['pidNumber'];
    dob = json['dob'];
    dateOfAdmission = json['dateOfAdmission'];
    age = json['age'];
    mobileNumber = json['mobileNumber'];
    aadharCardNumber = json['aadharCardNumber'];
    emailId = json['emailId'];
    aadharCardImage = json['aadharCardImage'];
    if (json['skillList'] != null) {
      skillList = <SkillList>[];
      json['skillList'].forEach((v) {
        skillList!.add(SkillList.fromJson(v));
      });
    }
    if (json['learningObjective'] != null) {
      learningObjective = <LearningObjective>[];
      json['learningObjective'].forEach((v) {
        learningObjective!.add(LearningObjective.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['studentId'] = studentId;
    data['image'] = image;
    data['genderId'] = genderId;
    data['gender'] = gender;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['middleName'] = middleName;
    data['diagnosis'] = diagnosis;
    data['pidNumber'] = pidNumber;
    data['dob'] = dob;
    data['dateOfAdmission'] = dateOfAdmission;
    data['age'] = age;
    data['mobileNumber'] = mobileNumber;
    data['aadharCardNumber'] = aadharCardNumber;
    data['emailId'] = emailId;
    data['aadharCardImage'] = aadharCardImage;
    if (skillList != null) {
      data['skillList'] = skillList!.map((v) => v.toJson()).toList();
    }
    if (learningObjective != null) {
      data['learningObjective'] =
          learningObjective!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SkillList {
  int? skillId;
  String? name;
  List<SkillRating>? skillRating;

  SkillList({this.skillId, this.name, this.skillRating});

  SkillList.fromJson(Map<String, dynamic> json) {
    skillId = json['skillId'];
    name = json['name'];
    if (json['skillRating'] != null) {
      skillRating = <SkillRating>[];
      json['skillRating'].forEach((v) {
        skillRating!.add(SkillRating.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['skillId'] = skillId;
    data['name'] = name;
    if (skillRating != null) {
      data['skillRating'] = skillRating!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SkillRating {
  int? qualityId;
  String? name;
  int? ratingId;
  int? studentSkillId;
  List<Quality>? quality;

  SkillRating(
      {this.qualityId,
        this.name,
        this.ratingId,
        this.studentSkillId,
        this.quality});

  SkillRating.fromJson(Map<String, dynamic> json) {
    qualityId = json['qualityId'];
    name = json['name'];
    ratingId = json['ratingId'];
    studentSkillId = json['studentSkillId'];
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
    data['ratingId'] = ratingId;
    data['studentSkillId'] = studentSkillId;
    if (quality != null) {
      data['quality'] = quality!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Quality {
  int? qualityId;
  int? qualityIdParentId;
  int? studentSkillId;
  int? ratingId;
  String? name;

  Quality(
      {this.qualityId,
        this.qualityIdParentId,
        this.studentSkillId,
        this.ratingId,
        this.name});

  Quality.fromJson(Map<String, dynamic> json) {
    qualityId = json['qualityId'];
    qualityIdParentId = json['qualityIdParentId'];
    studentSkillId = json['studentSkillId'];
    ratingId = json['ratingId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qualityId'] = qualityId;
    data['qualityIdParentId'] = qualityIdParentId;
    data['studentSkillId'] = studentSkillId;
    data['ratingId'] = ratingId;
    data['name'] = name;
    return data;
  }
}

class LearningObjective {
  List<LongTermGoal>? longTermGoal;
  List<WeeklyGoal>? weeklyGoal;

  LearningObjective({this.longTermGoal, this.weeklyGoal});

  LearningObjective.fromJson(Map<String, dynamic> json) {
    if (json['longTermGoal'] != null) {
      longTermGoal = <LongTermGoal>[];
      json['longTermGoal'].forEach((v) {
        longTermGoal!.add(LongTermGoal.fromJson(v));
      });
    }
    if (json['weeklyGoal'] != null) {
      weeklyGoal = <WeeklyGoal>[];
      json['weeklyGoal'].forEach((v) {
        weeklyGoal!.add(WeeklyGoal.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (longTermGoal != null) {
      data['longTermGoal'] = longTermGoal!.map((v) => v.toJson()).toList();
    }
    if (weeklyGoal != null) {
      data['weeklyGoal'] = weeklyGoal!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LongTermGoal {
  int? id;
  String? longTermGoal;

  LongTermGoal({this.id, this.longTermGoal});

  LongTermGoal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    longTermGoal = json['longTermGoal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['longTermGoal'] = longTermGoal;
    return data;
  }
}

class WeeklyGoal {
  int? id;
  int? weekCount;
  String? goals;
  String? durationDate;
  String? endDate;
  String? intervention;
  String? learningBarriers;
  String? learningOutcome;
  String? remarks;

  WeeklyGoal(
      {this.id,
        this.weekCount,
        this.goals,
        this.durationDate,
        this.endDate,
        this.intervention,
        this.learningBarriers,
        this.learningOutcome,
        this.remarks});

  WeeklyGoal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weekCount = json['weekCount'];
    goals = json['goals'];
    durationDate = json['durationDate'];
    endDate = json['endDate'];
    intervention = json['intervention'];
    learningBarriers = json['learningBarriers'];
    learningOutcome = json['learningOutcome'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['weekCount'] = weekCount;
    data['goals'] = goals;
    data['durationDate'] = durationDate;
    data['endDate'] = endDate;
    data['intervention'] = intervention;
    data['learningBarriers'] = learningBarriers;
    data['learningOutcome'] = learningOutcome;
    data['remarks'] = remarks;
    return data;
  }
}
