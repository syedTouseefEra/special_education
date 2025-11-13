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
  final String? imageUrl; // 🆕 Added
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final bool requiredField;
  final bool isUploading;

  const UploadBox({
    super.key,
    required this.title,
    required this.onTap,
    this.imageFile,
    this.imageUrl, // 🆕 Optional network image
    this.onClear,
    this.requiredField = false,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasLocalImage = imageFile != null;
    final hasNetworkImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        SizedBox(height: 8.sp),
        Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: isUploading ? null : onTap,
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  color: Colors.grey.shade400,
                  strokeWidth: 1,
                  dashPattern: const [6, 4],
                  radius: Radius.circular(6.r),
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.sp,
                    vertical: (!hasLocalImage && !hasNetworkImage)
                        ? 10.sp
                        : 2.sp,
                  ),
                  child: Row(
                    children: [
                      if (!hasLocalImage && !hasNetworkImage) ...[
                        Container(
                          height: 25.sp,
                          width: 25.sp,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Icon(Icons.upload_file, size: 20.sp),
                        ),
                        SizedBox(width: 12.sp),
                        Expanded(
                          child: CustomText(
                            text: 'Upload File',
                            color: Colors.grey.shade700,
                            fontSize: 14.sp,
                          ),
                        ),
                      ] else ...[
                        // 🆕 Display either network or local image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: hasLocalImage
                              ? Image.file(
                            imageFile!,
                            width: 40.sp,
                            height: 40.sp,
                            fit: BoxFit.cover,
                          )
                              : Image.network(
                            imageUrl!,
                            width: 40.sp,
                            height: 40.sp,
                            fit: BoxFit.cover,
                            errorBuilder: (context, _, __) => Container(
                              width: 40.sp,
                              height: 40.sp,
                              color: Colors.grey.shade300,
                              child: Icon(Icons.image_not_supported,
                                  size: 20.sp),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.r),
                        Expanded(
                          child: CustomText(
                            text: hasLocalImage
                                ? p.basename(imageFile!.path)
                                : imageUrl!.split('/').last,
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

            if (isUploading)
              Center(
                child: SizedBox(
                  height: 24.sp,
                  width: 24.sp,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.themeColor,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 6.sp),
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
        SizedBox(height: 15.sp),
        if (!hasLocalImage && !hasNetworkImage) ...[
          Container()
        ] else ...[
          Image.network(
            imageUrl!,
            width: 150.sp,
            height: 150.sp,
            fit: BoxFit.cover,
            errorBuilder: (context, _, __) => Container(
              width: 40.sp,
              height: 40.sp,
              color: Colors.grey.shade300,
              child: Icon(Icons.image_not_supported,
                  size: 20.sp),
            ),
          )
        ],
      ],
    );
  }
}

