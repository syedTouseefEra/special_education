import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:path/path.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/custom_widget/field_label_row.dart';
import 'package:special_education/utils/image_picker.dart';
import 'package:special_education/utils/image_uploader.dart';

class ImagePickerWithPreview extends StatelessWidget {
  final ValueNotifier<File?> imageFileNotifier;
  final ValueNotifier<String?> uploadedFileNameNotifier;
  final String? imageUrl;
  final String? title;
  final String? uploadedFolderName;
  final String uploadButtonText;
  final double containerHeight;
  final double thumbnailHeight;
  final double thumbnailWidth;
  final double fullscreenHeight;
  final String bottomSheetTitle;
  final bool requiredField;

  const ImagePickerWithPreview({
    required this.imageFileNotifier,
    required this.uploadedFileNameNotifier,
    this.imageUrl,
    this.title,
    this.uploadedFolderName,
    required this.uploadButtonText,
    required this.containerHeight,
    required this.thumbnailHeight,
    required this.thumbnailWidth,
    required this.fullscreenHeight,
    required this.bottomSheetTitle,
    this.requiredField = false,
    super.key,
  });

  // -------------------------------------------------------------------------
  // IMAGE PICKER POPUP
  // -------------------------------------------------------------------------
  void _showImagePickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(15.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.cancel_outlined, color: Colors.black, size: 20.h),
                  ),
                  CustomText(
                    text: bottomSheetTitle,
                    fontSize: 20.sp,
                    fontFamily: 'DMSerif',
                    fontWeight: FontWeight.w400,
                  ),
                  const Icon(Icons.delete_outline, color: Colors.transparent),
                ],
              ),

              SizedBox(height: 20.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // ================= GALLERY =================
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(const Duration(milliseconds: 300));

                      final pickedFile = await ImagePickerHelper.pickFromGallery();
                      await _validateAndUpload(pickedFile, context);
                    },
                    child: _iconTile(Icons.photo_library, "Gallery"),
                  ),

                  // ================= CAMERA =================
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(const Duration(milliseconds: 300));

                      final pickedFile = await ImagePickerHelper.pickFromCamera();
                      await _validateAndUpload(pickedFile, context);
                    },
                    child: _iconTile(Icons.camera_alt, "Camera"),
                  ),
                ],
              ),

              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------------------
  // REUSABLE TILE WIDGET
  // -------------------------------------------------------------------------
  Widget _iconTile(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(2.h),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey, width: 1.w),
          ),
          child: CircleAvatar(
            radius: 15.h,
            backgroundColor: Colors.grey.shade200,
            child: Icon(icon, color: AppColors.themeColor, size: 20.h),
          ),
        ),
        SizedBox(height: 8.h),
        Text(label, style: TextStyle(fontSize: 14.sp)),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // VALIDATE AND UPLOAD FILE
  // -------------------------------------------------------------------------
  Future<void> _validateAndUpload(File? pickedFile, BuildContext context) async {
    if (pickedFile == null) return;

    final fileSize = await pickedFile.length();

    if (fileSize > 5 * 1024 * 1024) {
      showSnackBar('Image exceeds 5 MB limit. Please select a smaller one', context);
      return;
    }

    final uploadedFileName = await ImageUploaderHelper.uploadProfileImage(
      filePath: pickedFile.path,
      context: context,
      folderId: '1',
    );

    if (uploadedFileName != null) {
      imageFileNotifier.value = pickedFile;
      uploadedFileNameNotifier.value = uploadedFileName;
      print("uploadedFileNameNotifier "+uploadedFileNameNotifier.value.toString());
    }
  }

  // -------------------------------------------------------------------------
  // FULLSCREEN IMAGE PREVIEW
  // -------------------------------------------------------------------------
  void _showFullScreenImage(BuildContext context, Widget imageWidget) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(10),
        backgroundColor: AppColors.lightTransparent,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: SizedBox(
            height: fullscreenHeight.h,
            width: double.infinity,
            child: InteractiveViewer(child: imageWidget),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // MAIN BUILD WIDGET
  // -------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<File?>(
      valueListenable: imageFileNotifier,
      builder: (_, imageFile, __) {
        return ValueListenableBuilder<String?>(
          valueListenable: uploadedFileNameNotifier,
          builder: (_, uploadedFileName, __) {
            Widget? previewImage;

            // Local picked image
            if (imageFile != null) {
              previewImage = GestureDetector(
                onTap: () => _showFullScreenImage(
                  context,
                  Image.file(imageFile, fit: BoxFit.contain),
                ),
                child: Image.file(
                  imageFile,
                  height: thumbnailHeight.h,
                  width: thumbnailWidth.w,
                  fit: BoxFit.fill,
                ),
              );
            }
            // Uploaded image
            else if (uploadedFileName != null && uploadedFileName.isNotEmpty) {
              final String fullUrl = (uploadedFolderName == null ||
                  uploadedFolderName!.isEmpty)
                  ? "${ApiServiceUrl.urlLauncher}Uploads/$uploadedFileName"
                  : "${ApiServiceUrl.urlLauncher}$uploadedFolderName/$uploadedFileName";
              previewImage = GestureDetector(
                onTap: () => _showFullScreenImage(
                  context,
                  Image.network(fullUrl, fit: BoxFit.contain),
                ),
                child: Image.network(
                  fullUrl,
                  height: thumbnailHeight.h,
                  width: thumbnailWidth.w,
                  fit: BoxFit.fill,
                ),
              );
            }
            // Existing image URL
            else if (imageUrl != null && imageUrl!.isNotEmpty) {
              previewImage = GestureDetector(
                onTap: () => _showFullScreenImage(
                  context,
                  Image.network(imageUrl!, fit: BoxFit.contain),
                ),
                child: Image.network(
                  imageUrl!,
                  height: thumbnailHeight.h,
                  width: thumbnailWidth.w,
                  fit: BoxFit.fill,
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------- UPLOAD BUTTON + FILE NAME ROW ----------------
                FieldLabel(
                  text: title ?? "",
                  isRequired: requiredField,
                  fontSize: 13.sp,
                  color: AppColors.black,
                ),
                SizedBox(height: 5.sp,),
                DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    color: Colors.grey.shade400,
                    strokeWidth: 1,
                    dashPattern: const [6, 4],
                    radius: Radius.circular(6.r),
                    padding: EdgeInsets.zero,
                  ),

                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 8.sp),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => _showImagePickerModal(context),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.sp,
                              vertical: 2.sp,
                            ),
                            child: CustomText(
                              text: uploadButtonText,
                              fontSize: 11.h,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: CustomText(
                            text: uploadedFileName ??
                                (imageFile != null
                                    ? basename(imageFile.path)
                                    : imageUrl != null
                                    ? basename(imageUrl!)
                                    : ""),
                            maxLines: 2,
                            fontSize: 10,
                          ),
                        ),

                        // Clear Button
                        if (imageFile != null || uploadedFileName != null)
                          InkWell(
                            onTap: () {
                              imageFileNotifier.value = null;
                              uploadedFileNameNotifier.value = null;
                            },
                            child: Icon(Icons.close, size: 15.h, color: AppColors.red),
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(Icons.error_outline,size: 12.sp,color: AppColors.yellow,),
                    SizedBox(width: 3.sp,),
                    CustomText(text: "File should be JPG/PNG (max 5MB)",fontSize: 10.sp,color: AppColors.textGrey,),
                  ],
                ),

                if (previewImage != null) ...[
                  SizedBox(height: 8.h),
                  previewImage,
                ],
              ],
            );
          },
        );
      },
    );
  }
}
