


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:special_education/api_service/api_calling_types.dart';

class ImageUploaderHelper {
  static Future<String?> uploadProfileImage({
    required String filePath,
    required BuildContext context,
    required String folderId,
  }) async {
    try {
      final result = await ApiCallingTypes(baseUrl: '')
          .uploadFile(filePath: filePath, folderId: folderId);
      final decoded = jsonDecode(result);
      final fileName = decoded['data'][0]['fileName'];
      return fileName;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}

