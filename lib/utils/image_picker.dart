import 'dart:io';
import 'package:flutter/Material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery
  static Future<File?> pickFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      debugPrint("Picked file path: ${pickedFile.path}");
      return File(pickedFile.path);
    }
    return null;
  }

  /// Pick image from camera
  static Future<File?> pickFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      debugPrint("Picked file path: ${pickedFile.path}");
      return File(pickedFile.path);
    }
    return null;
  }

  /// Pick video from gallery
  static Future<File?> pickVideoFromGallery() async {
    final pickedVideo = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      debugPrint("Picked file path: ${pickedVideo.path}");
      return File(pickedVideo.path);
    }
    return null;
  }

  /// Pick video from camera (optional)
  static Future<File?> pickVideoFromCamera() async {
    final pickedVideo = await _picker.pickVideo(source: ImageSource.camera);
    if (pickedVideo != null) {
      debugPrint("Picked file path: ${pickedVideo.path}");
      return File(pickedVideo.path);
    }
    return null;
  }
}
