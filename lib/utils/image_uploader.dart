//
//
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:e_learning/api_service/api_calling_types.dart';
//
// class ImageUploaderHelper {
//   static Future<String?> uploadProfileImage({
//     required WidgetRef ref,
//     required String filePath,
//     required BuildContext context,
//     required String folderId,
//   }) async {
//     try {
//       final result = await ApiCallingTypes(baseUrl: '')
//           .uploadFile(filePath: filePath, folderId: folderId);
//       final decoded = jsonDecode(result);
//       final fileName = decoded['data'][0]['fileName'];
//       return fileName;
//     } catch (e) {
//       print('Error: $e');
//       return null;
//     }
//   }
// }
//
