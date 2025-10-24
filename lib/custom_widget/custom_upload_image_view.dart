import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as p;
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/field_label_row.dart';

class UploadBox extends StatelessWidget {
  final String title;
  final File? imageFile;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final bool requiredField;

  const UploadBox({
    super.key,
    required this.title,
    required this.onTap,
    this.imageFile,
    this.onClear,
    this.requiredField = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 Title + required mark
        Row(
          children: [
            FieldLabel(
              text: title,
              isRequired: requiredField,
              fontSize: 14.sp,
              color: AppColors.black,
            ),
          ],
        ),
        const SizedBox(height: 8),

        /// 🔹 Upload area
        GestureDetector(
          onTap: onTap,
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              color: Colors.grey.shade400,
              strokeWidth: 1,
              dashPattern: const [6, 4],
              radius: const Radius.circular(6),
              padding: EdgeInsets.zero,
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 12.sp,
                vertical: imageFile == null ? 10.sp : 2.sp,
              ),
              child: Row(
                children: [
                  if (imageFile == null) ...[
                    Container(
                      height: 25.sp,
                      width: 25.sp,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Icon(Icons.upload_file, size: 20.sp),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomText(
                        text: 'Upload File',
                        color: Colors.grey.shade700,
                        fontSize: 14.sp,
                      ),
                    ),
                  ] else ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.file(
                        imageFile!,
                        width: 30.sp,
                        height: 30.sp,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomText(
                        text: p.basename(imageFile!.path),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (onClear != null)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: onClear,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 6),

        Row(
          children: [
            Icon(Icons.error_outline, size: 16.sp, color: Colors.orange),
            SizedBox(width: 3.sp),
            CustomText(
              text: 'File should be in jpg/png format (5 MB).',
              color: Colors.grey.shade600,
              fontSize: 10.sp,
            ),
          ],
        ),
      ],
    );
  }
}
