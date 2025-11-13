import 'dart:io';
import 'package:flutter/material.dart';
import 'package:special_education/custom_widget/custom_upload_image_view.dart';

class UploadImageBox extends StatelessWidget {
  final String title;
  final File? imageFile;
  final VoidCallback onTap;
  final VoidCallback onClear;
  final bool requiredField;

  const UploadImageBox({
    super.key,
    required this.title,
    required this.imageFile,
    required this.onTap,
    required this.onClear,
    this.requiredField = false,
  });

  @override
  Widget build(BuildContext context) {
    return UploadBox(
      title: title,
      imageFile: imageFile,
      onTap: onTap,
      onClear: onClear,
      requiredField: requiredField,
    );
  }
}
