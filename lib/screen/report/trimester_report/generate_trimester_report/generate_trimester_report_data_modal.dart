

class TrimesterGenerateReportDataModel {
  int? id;
  int? trimesterId;
  int? studentId;
  int? qualityId;
  String? name;
  String? remarks;
  int? star;
  int? selectedStar;
  List<SkillQualityParent>? skillQualityParent;

  TrimesterGenerateReportDataModel(
      {this.id,
        this.trimesterId,
        this.studentId,
        this.qualityId,
        this.name,
        this.remarks,
        this.star,
        this.selectedStar,
        this.skillQualityParent});

  TrimesterGenerateReportDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trimesterId = json['trimesterId'];
    studentId = json['studentId'];
    qualityId = json['qualityId'];
    name = json['name'];
    remarks = json['remarks'];
    star = json['star'];
    selectedStar = json['selectedStar'];
    if (json['skillQualityParent'] != null) {
      skillQualityParent = <SkillQualityParent>[];
      json['skillQualityParent'].forEach((v) {
        skillQualityParent!.add(SkillQualityParent.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['trimesterId'] = trimesterId;
    data['studentId'] = studentId;
    data['qualityId'] = qualityId;
    data['name'] = name;
    data['remarks'] = remarks;
    data['star'] = star;
    data['selectedStar'] = selectedStar;
    if (skillQualityParent != null) {
      data['skillQualityParent'] =
          skillQualityParent!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SkillQualityParent {
  int? trimesterReportId;
  int? qualityId;
  int? qualityParentId;
  String? name;
  int? ratingId;

  SkillQualityParent(
      {this.trimesterReportId,
        this.qualityId,
        this.qualityParentId,
        this.name,
        this.ratingId});

  SkillQualityParent.fromJson(Map<String, dynamic> json) {
    trimesterReportId = json['trimesterReportId'];
    qualityId = json['qualityId'];
    qualityParentId = json['qualityParentId'];
    name = json['name'];
    ratingId = json['ratingId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trimesterReportId'] = trimesterReportId;
    data['qualityId'] = qualityId;
    data['qualityParentId'] = qualityParentId;
    data['name'] = name;
    data['ratingId'] = ratingId;
    return data;
  }
}