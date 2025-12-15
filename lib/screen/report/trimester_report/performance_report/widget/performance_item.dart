import 'package:flutter/Material.dart';

class PerformanceItem {
  String name;
  int ratingId;
  TextEditingController remarkController;

  PerformanceItem({
    required this.name,
    this.ratingId = 0,
    required this.remarkController,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "ratingId": ratingId,
      "remarks": remarkController.text,
    };
  }
}
