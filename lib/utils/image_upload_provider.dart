import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:special_education/api_service/api_calling_types.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/alert_view.dart';

class ImageUploadProvider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  File? teacherImage;
  File? aadharImage;
  File? signatureImage;

  String? teacherImageUrl;
  String? aadharImageUrl;
  String? signatureImageUrl;

  bool isUploading = false;
  final double maxSizeMB;

  ImageUploadProvider({this.maxSizeMB = 5});

  Future<void> pickAndUploadImage(BuildContext context, String type) async {
    try {
      final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);

      if (picked == null) {
        showSnackBar("No image selected", context);
        return;
      }

      final isValid = await _checkImageSize(picked, context);
      if (!isValid) return;

      final file = File(picked.path);

      switch (type.toLowerCase()) {
        case 'aadhar':
          aadharImage = file;
          break;
        case 'teacher':
          teacherImage = file;
          break;
        case 'signature':
          signatureImage = file;
          break;
        default:
          showSnackBar("Unknown image type: $type", context);
          return;
      }

      notifyListeners();

      isUploading = true;
      notifyListeners();

      final uploadedName = await uploadImageWithLoader(file.path, context);
      if (uploadedName != null) {
        switch (type.toLowerCase()) {
          case 'aadhar':
            aadharImageUrl = uploadedName;
            break;
          case 'teacher':
            teacherImageUrl = uploadedName;
            break;
          case 'signature':
            signatureImageUrl = uploadedName;
            break;
        }
        final capitalizedType = type[0].toUpperCase() + type.substring(1).toLowerCase();

        showSnackBar("✅ $capitalizedType image uploaded successfully", context);
      }

    } catch (e) {
      showSnackBar("Error picking or uploading image: $e", context);
      if (kDebugMode) print('❌ pickAndUploadImage error: $e');
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  Future<bool> _checkImageSize(XFile imageFile, BuildContext context) async {
    final int fileSizeInBytes = await imageFile.length();
    final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

    if (fileSizeInMB > maxSizeMB) {
      showSnackBar("Image size must be less than $maxSizeMB MB", context);
      return false;
    }
    return true;
  }

  Future<String?> uploadImageWithLoader(String filePath, BuildContext context) async {
    final apiCaller = ApiCallingTypes(baseUrl: '');

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      pageBuilder: (context, anim1, anim2) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      String result = await apiCaller.uploadFileByMultipart(
        filePath: filePath,
        folderName: 'Uploads',
        authToken: ApiServiceUrl.token,
      );

      if (result.startsWith('Failed') || result.startsWith('Error')) {
        throw Exception(result);
      }

      final decoded = jsonDecode(result);
      final uploadedFileName = decoded['data'];

      if (kDebugMode) print('📤 Uploaded File Name: $uploadedFileName');

      return uploadedFileName;
    } catch (e) {
      if (kDebugMode) print('❌ Upload failed: $e');
      showSnackBar('Failed to upload image', context);
      return null;
    } finally {
      // Hide loader
      Navigator.of(context, rootNavigator: true).pop();
    }
  }


  void clearImage(String type) {
    switch (type.toLowerCase()) {
      case 'aadhar':
        aadharImage = null;
        aadharImageUrl = null;
        break;
      case 'teacher':
        teacherImage = null;
        teacherImageUrl = null;
        break;
      case 'signature':
        signatureImage = null;
        signatureImageUrl = null;
        break;
    }
    notifyListeners();
  }
}
