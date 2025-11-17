import 'dart:io';
import 'package:flutter/material.dart';
import 'package:special_education/custom_widget/custom_upload_image_view.dart';

class UploadImageBox extends StatelessWidget {
  final String title;
  final File? imageFile;
  final String? imageUrl;
  final VoidCallback onTap;
  final VoidCallback onClear;
  final bool requiredField;
  final bool isUploading;
  final bool isUpdatingProfile;

  const UploadImageBox({
    super.key,
    required this.title,
    required this.imageFile,
    required this.onTap,
    required this.onClear,
    this.imageUrl,
    this.requiredField = false,
    this.isUploading = false,
    this.isUpdatingProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    return UploadBox(
      title: title,
      imageFile: imageFile,
      imageUrl: imageUrl,
      onTap: onTap,
      onClear: onClear,
      requiredField: requiredField,
      isUploading: isUploading,
      isUpdatingProfile: isUpdatingProfile,
    );
  }
}
