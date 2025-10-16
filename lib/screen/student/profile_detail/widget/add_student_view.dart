import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:special_education/components/custom_appbar.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/custom_upload_image_view.dart';
import 'package:special_education/custom_widget/field_label_row.dart';
import 'package:special_education/custom_widget/text_field.dart';
import 'package:special_education/utils/date_picker_utils.dart';

class AddStudentView extends StatefulWidget {
  const AddStudentView({super.key});

  @override
  State<AddStudentView> createState() => _AddStudentViewState();
}

class _AddStudentViewState extends State<AddStudentView> {
  final TextEditingController firstName = TextEditingController();
  DateTime selectedDate = DateTime.now();
  File? _studentImage;

  /// 🖼️ Pick student photo
  Future<void> _pickStudentImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _studentImage = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: const CustomAppBar(enableTheming: false),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.sp, vertical: 15.sp),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: 'Add Student',
                    fontSize: 22.sp,
                    color: AppColors.themeColor,
                    fontFamily: 'Dm Serif',
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 10.sp),

                  /// Section Header
                  CustomText(
                    text: 'General Information',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 5.sp),
                  const Divider(thickness: 1),

                  SizedBox(height: 10.sp),
                  FieldLabel(
                    text: "First Name",
                    isRequired: true,
                    fontSize: 14.sp,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 5.sp),
                  CustomTextField(
                    controller: firstName,
                    borderRadius: 8.sp,
                    borderColor: AppColors.grey,
                    label: 'Enter your name',
                  ),
                  SizedBox(height: 7.sp),

                  FieldLabel(
                    text: "Middle Name",
                    fontSize: 14.sp,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 5.sp),
                  CustomTextField(
                    controller: firstName,
                    borderRadius: 8.sp,
                    borderColor: AppColors.grey,
                    label: 'Enter middle name',
                  ),
                  SizedBox(height: 7.sp),

                  FieldLabel(
                    text: "Last Name",
                    fontSize: 14.sp,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 5.sp),
                  CustomTextField(
                    controller: firstName,
                    borderRadius: 8.sp,
                    borderColor: AppColors.grey,
                    label: 'Enter last name',
                  ),
                  SizedBox(height: 7.sp),

                  FieldLabel(
                    text: "Mobile Number",
                    isRequired: true,
                    fontSize: 14.sp,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 5.sp),
                  CustomTextField(
                    controller: firstName,
                    borderRadius: 8.sp,
                    borderColor: AppColors.grey,
                    label: 'Enter mobile number',
                  ),
                  SizedBox(height: 7.sp),

                  FieldLabel(
                    text: "Email ID",
                    fontSize: 14.sp,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 5.sp),
                  CustomTextField(
                    controller: firstName,
                    borderRadius: 8.sp,
                    borderColor: AppColors.grey,
                    label: 'Enter email id',
                  ),
                  SizedBox(height: 7.sp),

                  FieldLabel(
                    text: "Diagnosis",
                    isRequired: true,
                    fontSize: 14.sp,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 5.sp),
                  CustomTextField(
                    controller: firstName,
                    borderRadius: 8.sp,
                    borderColor: AppColors.grey,
                    label: 'Enter diagnosis',
                  ),
                  SizedBox(height: 7.sp),

                  FieldLabel(
                    text: "Date of Birth",
                    isRequired: true,
                    fontSize: 14.sp,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 5.sp),
                  DatePickerHelper.datePicker(
                    borderColor: AppColors.grey,
                    iconColor: AppColors.grey,
                    context,
                    date: selectedDate,
                    onChanged: (newDate) {
                      setState(() => selectedDate = newDate);
                    },
                  ),

                  SizedBox(height: 7.sp),
                  FieldLabel(
                    text: "Gender",
                    isRequired: true,
                    fontSize: 14.sp,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 5.sp),
                  CustomTextField(
                    isEditable: false,
                    controller: firstName,
                    borderRadius: 8.sp,
                    borderColor: AppColors.grey,
                    label: 'Select Gender',
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                  ),

                  SizedBox(height: 7.sp),
                  FieldLabel(
                    text: "PID Number",
                    isRequired: true,
                    fontSize: 14.sp,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 5.sp),
                  CustomTextField(
                    controller: firstName,
                    borderRadius: 8.sp,
                    borderColor: AppColors.grey,
                    label: 'Enter PID',
                  ),

                  SizedBox(height: 25.sp),

                  CustomText(
                    text: 'Address Details',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 5.sp),
                  const Divider(thickness: 1),

                  SizedBox(height: 7.sp),
                  FieldLabel(
                    text: "Pincode",
                    fontSize: 14.sp,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 5.sp),
                  CustomTextField(
                    controller: firstName,
                    borderRadius: 8.sp,
                    borderColor: AppColors.grey,
                    label: 'Enter Pincode',
                  ),
                  SizedBox(height: 7.sp),

                  SizedBox(height: 7.sp),
                  FieldLabel(
                    text: "Address Line 1",
                    fontSize: 14.sp,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 5.sp),
                  CustomTextField(
                    controller: firstName,
                    borderRadius: 8.sp,
                    borderColor: AppColors.grey,
                    label: 'Enter Address',
                  ),
                  SizedBox(height: 7.sp),

                  SizedBox(height: 7.sp),
                  FieldLabel(
                    text: "Address Line 2",
                    fontSize: 14.sp,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 5.sp),
                  CustomTextField(
                    controller: firstName,
                    borderRadius: 8.sp,
                    borderColor: AppColors.grey,
                    label: 'Enter Address',
                  ),
                  SizedBox(height: 7.sp),

                  SizedBox(height: 7.sp),
                  FieldLabel(
                    text: "Country",
                    fontSize: 14.sp,
                    color: AppColors.black,
                    isRequired: true,
                  ),
                  SizedBox(height: 5.sp),
                  CustomTextField(
                    controller: firstName,
                    borderRadius: 8.sp,
                    borderColor: AppColors.grey,
                    label: 'Enter Country',
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                  ),
                  SizedBox(height: 7.sp),

                  SizedBox(height: 7.sp),
                  FieldLabel(
                    text: "State",
                    fontSize: 14.sp,
                    color: AppColors.black,
                    isRequired: true,
                  ),
                  SizedBox(height: 5.sp),
                  CustomTextField(
                    controller: firstName,
                    borderRadius: 8.sp,
                    borderColor: AppColors.grey,
                    label: 'Enter State',
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                  ),
                  SizedBox(height: 7.sp),

                  SizedBox(height: 7.sp),
                  FieldLabel(
                    text: "City/Town",
                    fontSize: 14.sp,
                    color: AppColors.black,
                    isRequired: true,
                  ),
                  SizedBox(height: 5.sp),
                  CustomTextField(
                    controller: firstName,
                    borderRadius: 8.sp,
                    borderColor: AppColors.grey,
                    label: 'Enter City/Town',
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                  ),
                  SizedBox(height: 7.sp),


                  /// ---------------- Additional Details ----------------
                  SizedBox(height: 25.sp),
                  CustomText(
                    text: 'Additional Details',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 5.sp),
                  const Divider(thickness: 1),

                  SizedBox(height: 7.sp),
                  FieldLabel(
                    text: "Nationality",
                    isRequired: true,
                    fontSize: 14.sp,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 5.sp),
                  CustomTextField(
                    isEditable: false,
                    controller: firstName,
                    borderRadius: 8.sp,
                    borderColor: AppColors.grey,
                    label: 'Enter Nationality',
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                  ),
                  SizedBox(height: 7.sp),

                  FieldLabel(
                    text: "Aadhar Card Number",
                    isRequired: true,
                    fontSize: 14.sp,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 5.sp),
                  CustomTextField(
                    controller: firstName,
                    borderRadius: 8.sp,
                    borderColor: AppColors.grey,
                    label: 'Enter Aadhar Card Number',
                  ),

                  SizedBox(height: 7.sp),
                  UploadBox(
                    title: "Aadhar Card Image",
                    imageFile: _studentImage,
                    onTap: _pickStudentImage,
                    onClear: () => setState(() => _studentImage = null),
                    requiredField: true,
                  ),
                  SizedBox(height: 15.sp),
                  UploadBox(
                    title: "Student Image",
                    imageFile: _studentImage,
                    onTap: _pickStudentImage,
                    onClear: () => setState(() => _studentImage = null),
                    requiredField: true,
                  ),
                  SizedBox(height: 40.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomContainer(
                        text: 'Save And Continue',
                        fontWeight: FontWeight.w400,
                        padding: 5.sp,
                        innerPadding: EdgeInsets.symmetric(horizontal: 18.sp,vertical: 10.sp),
                        borderRadius: 20.r,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
