import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/api_service/api_calling_types.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_confirmation_dialog.dart';
import 'package:special_education/utils/image_picker.dart';

class ImagePickerModalHelper {
  static void showImagePickerModal({
    required BuildContext context,
    required BuildContext parentContext,
    String bottomSheetTitle = "Upload Image",
    Function(String fileName)? onImageUploaded, // NEW CALLBACK
  }) {
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
                    child: Icon(Icons.cancel_outlined,
                        color: Colors.black, size: 20.h),
                  ),
                  Text(
                    bottomSheetTitle,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'DMSerif',
                      color: AppColors.black,
                    ),
                  ),
                  Icon(Icons.delete_outline,
                      color: Colors.transparent, size: 20.h),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(Duration(milliseconds: 300));

                      final pickedFile =
                      await ImagePickerHelper.pickFromGallery();

                      if (pickedFile != null) {
                        showDialog(
                          context: parentContext,
                          builder: (context) => CustomConfirmationDialog(
                            title:
                            'Do you want to \nupload the selected image?',
                            confirmText: 'Upload',
                            cancelText: 'Cancel',
                            onConfirm: () async {
                              Navigator.pop(context);
                              await _uploadImage(
                                pickedFile.path,
                                parentContext,
                                onImageUploaded,
                              );
                            },
                            onCancel: () => Navigator.pop(context),
                          ),
                        );
                      }
                    },
                    child: Column(
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
                            child: Icon(Icons.photo_library,
                                color: AppColors.themeColor, size: 20.h),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text("Gallery", style: TextStyle(fontSize: 14.sp)),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      await Future.delayed(Duration(milliseconds: 300));

                      final pickedFile =
                      await ImagePickerHelper.pickFromCamera();

                      if (pickedFile != null) {
                        await _uploadImage(
                          pickedFile.path,
                          parentContext,
                          onImageUploaded,
                        );
                      }
                    },
                    child: Column(
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
                            child: Icon(Icons.camera_alt,
                                color: AppColors.themeColor, size: 20.h),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text("Camera", style: TextStyle(fontSize: 14.sp)),
                      ],
                    ),
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

  static Future<void> _uploadImage(
      String filePath,
      BuildContext context,
      Function(String fileName)? onImageUploaded,
      ) async {
    final apiCaller = ApiCallingTypes(baseUrl: 'YOUR_BASE_URL');

    try {
      String result =
      await apiCaller.uploadFile(filePath: filePath, folderId: '1');

      final decoded = jsonDecode(result);
      final fileName = decoded['data'][0]['fileName'];

      if (kDebugMode) print('📁 File Name: $fileName');

      // 🔥 Callback instead of ref providers
      if (onImageUploaded != null) {
        onImageUploaded(fileName);
      }
    } catch (e) {
      if (kDebugMode) print('❌ Error uploading image: $e');
      showSnackBar("Failed to upload image", context);
    }
  }
}

