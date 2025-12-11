import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_image_picker_preview.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/field_label_row.dart';
import 'package:special_education/custom_widget/text_field.dart';

class UpdateAdditionalDetailsView extends StatefulWidget {
  const UpdateAdditionalDetailsView({super.key});

  @override
  State<UpdateAdditionalDetailsView> createState() =>
      _UpdateAdditionalDetailsViewState();
}

class _UpdateAdditionalDetailsViewState
    extends State<UpdateAdditionalDetailsView> {
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController aadharCardNumberController = TextEditingController();

  late final ValueNotifier<File?> studentImageNotifier;
  late final ValueNotifier<File?> aadhaarImageFrontNotifier;
  late final ValueNotifier<File?> aadhaarImageBackNotifier;
  late final ValueNotifier<String?> studentUploadedFileNameNotifier;
  late final ValueNotifier<String?> aadhaarFrontUploadedFileNameNotifier;
  late final ValueNotifier<String?> aadhaarBackUploadedFileNameNotifier;

  @override
  void initState() {
    super.initState();

    studentImageNotifier = ValueNotifier<File?>(null);
    aadhaarImageFrontNotifier = ValueNotifier<File?>(null);
    aadhaarImageBackNotifier = ValueNotifier<File?>(null);

    studentUploadedFileNameNotifier = ValueNotifier<String?>(null);
    aadhaarFrontUploadedFileNameNotifier = ValueNotifier<String?>(null);
    aadhaarBackUploadedFileNameNotifier = ValueNotifier<String?>(null);
  }

  @override
  void dispose() {
    nationalityController.dispose();
    aadharCardNumberController.dispose();

    studentImageNotifier.dispose();
    aadhaarImageFrontNotifier.dispose();
    aadhaarImageBackNotifier.dispose();
    studentUploadedFileNameNotifier.dispose();
    aadhaarFrontUploadedFileNameNotifier.dispose();
    aadhaarBackUploadedFileNameNotifier.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Additional Details",
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          Divider(thickness: 0.5.sp, color: AppColors.darkGrey),
          SizedBox(height: 10.sp),

          FieldLabel(text: "Nationality",isRequired: true,),
          SizedBox(height: 3.sp,),
          CustomTextField(
            fontSize: 13.sp,
            controller: nationalityController,
            borderRadius: 5.r,
            borderColor: Colors.grey,
            fillColor: Colors.grey.shade200,
            isEditable: true,
          ),
          SizedBox(height: 2.sp),

          FieldLabel(text: "Aadhar Card Number",isRequired: true),
          SizedBox(height: 3.sp,),
          CustomTextField(
            fontSize: 13.sp,
            controller: aadharCardNumberController,
            borderRadius: 5,
            borderColor: Colors.grey,
            fillColor: Colors.grey.shade200,
            isEditable: true,
          ),
          SizedBox(height: 2.sp),

          SizedBox(height: 10.h),
          FieldLabel(text: "Student Image"),
          SizedBox(height: 3.sp,),
          ImagePickerWithPreview(
            imageFileNotifier: studentImageNotifier,
            // imageUrl: '${ApiServiceUrl.urlLauncher}Documents/${student.image}',
            uploadButtonText: "Upload Image",
            containerHeight: 40,
            thumbnailHeight: 120,
            thumbnailWidth: 200,
            fullscreenHeight: 500,
            bottomSheetTitle: 'Update Student Image',
            uploadedFileNameNotifier: studentUploadedFileNameNotifier,
          ),
          SizedBox(height: 20.h),

          FieldLabel(text: "Aadhar Card Image"),
          SizedBox(height: 3.sp,),
          ImagePickerWithPreview(
            imageFileNotifier: aadhaarImageFrontNotifier,
            // imageUrl:
            // '${ApiServiceUrl.urlLauncher}Documents/${student.adharCardImage}',
            uploadButtonText: "Upload Image",
            containerHeight: 40,
            thumbnailHeight: 120,
            thumbnailWidth: 200,
            fullscreenHeight: 500,
            bottomSheetTitle: 'Update Aadhar Card Image',
            uploadedFileNameNotifier: aadhaarFrontUploadedFileNameNotifier,
          ),

          SizedBox(height: 20.h),

          FieldLabel(text: "Aadhar Card Image"),
          SizedBox(height: 3.sp,),
          ImagePickerWithPreview(
            imageFileNotifier: aadhaarImageBackNotifier,
            // imageUrl:
            // '${ApiServiceUrl.urlLauncher}Documents/${student.adharCardImage}',
            uploadButtonText: "Upload Image",
            containerHeight: 40,
            thumbnailHeight: 120,
            thumbnailWidth: 200,
            fullscreenHeight: 500,
            bottomSheetTitle: 'Update Aadhar Card Image',
            uploadedFileNameNotifier: aadhaarBackUploadedFileNameNotifier,
          ),
          SizedBox(height: 10.h),

        ],
      ),
    );
  }
}
