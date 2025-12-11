import 'dart:io';

import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_dropdown_form_field.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/custom_widget/custom_image_picker_preview.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/field_label_row.dart';
import 'package:special_education/custom_widget/text_field.dart';
import 'package:special_education/screen/student/profile_detail/add_student/widgets/save_button.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final TextEditingController instituteEmailController =
      TextEditingController();
  late final ValueNotifier<File?> instituteLogoNotifier;
  late final ValueNotifier<String?> instituteLogoNameNotifier;

  @override
  void initState() {
    super.initState();

    instituteLogoNotifier = ValueNotifier<File?>(null);
    instituteLogoNameNotifier = ValueNotifier<String?>(null);
  }

  @override
  void dispose() {
    instituteLogoNotifier.dispose();
    instituteLogoNameNotifier.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.sp),
            child: Column(
              children: [
                SizedBox(height: 5.sp),
                CustomHeaderView(courseName: "", moduleName: "Sing Up"),
                Divider(thickness: 0.7.sp),
              ]
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.sp,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Enter Details To Create Your Institute",
                        fontSize: 18.sp,
                        color: AppColors.themeColor,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 5.sp),
                      CustomText(
                        text: "Tell Us About You and Your Institute",
                        fontSize: 14.sp,
                        color: AppColors.textGrey,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(height: 10.sp),
                      FieldLabel(text: "Select Country", isRequired: true),
                      SizedBox(height: 3.sp),
                      CustomDropdownFormField(
                        items: [],
                        selectedValue: '',
                        hintText: 'Select Country',
                        onChanged: (String? p1) {},
                      ),
                      SizedBox(height: 12.sp),

                      FieldLabel(text: "Institute Email", isRequired: true),
                      SizedBox(height: 3.sp),
                      CustomTextField(
                        fontSize: 13.sp,
                        controller: instituteEmailController,
                        borderRadius: 5,
                        borderColor: Colors.grey,
                        fillColor: Colors.grey.shade200,
                        isEditable: true,
                        isEmail: true,
                      ),

                      FieldLabel(
                        text: "Institute Registration No.",
                        isRequired: true,
                      ),
                      SizedBox(height: 3.sp),
                      CustomTextField(
                        fontSize: 13.sp,
                        controller: instituteEmailController,
                        borderRadius: 5,
                        borderColor: Colors.grey,
                        fillColor: Colors.grey.shade200,
                        isEditable: true,
                        bottomSpacing: 3.sp,
                      ),
                      FieldLabel(
                        text: "Institute Registration No. can not be changed later",showLeadingIcon: true,
                        fontSize: 10.sp,
                        color: AppColors.textGrey ,
                      ),
                      SizedBox(height: 15.sp),

                      FieldLabel(
                        text: "Enter Your Institute Name",
                        isRequired: true,
                      ),
                      SizedBox(height: 3.sp),
                      CustomTextField(
                        fontSize: 13.sp,
                        controller: instituteEmailController,
                        borderRadius: 5,
                        borderColor: Colors.grey,
                        fillColor: Colors.grey.shade200,
                        isEditable: true,
                      ),

                      SizedBox(height: 25.sp),
                      CustomText(text: "Current Academic Year"),
                      SizedBox(height: 10.sp),
                      FieldLabel(text: "Name Of Current Academic Session", isRequired: true),
                      SizedBox(height: 3.sp),
                      CustomTextField(
                        fontSize: 13.sp,
                        controller: instituteEmailController,
                        borderRadius: 5,
                        borderColor: Colors.grey,
                        fillColor: Colors.grey.shade200,
                        isEditable: true,
                        bottomSpacing: 0,
                      ),
                      SizedBox(height: 15.sp),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FieldLabel(text: "Start Date", isRequired: true),
                                SizedBox(height: 3.sp),
                                CustomDropdownFormField(
                                  items: [],
                                  selectedValue: '',
                                  hintText: 'dd/mm/yyyy',
                                  onChanged: (String? p1) {},
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20.sp),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FieldLabel(text: "End Date", isRequired: true),
                                SizedBox(height: 3.sp),
                                CustomDropdownFormField(
                                  items: [],
                                  selectedValue: '',
                                  hintText: 'dd/mm/yyyy',
                                  onChanged: (String? p1) {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.sp),
                      FieldLabel(text: "Institute Logo", isRequired: true,),
                      SizedBox(height: 3.sp),
                      ImagePickerWithPreview(
                        imageFileNotifier: instituteLogoNotifier,
                        // imageUrl:
                        // '${ApiServiceUrl.urlLauncher}Documents/${student.adharCardImage}',
                        uploadButtonText: "Upload Image",
                        containerHeight: 40,
                        thumbnailHeight: 120,
                        thumbnailWidth: 200,
                        fullscreenHeight: 500,
                        bottomSheetTitle: 'Update Aadhar Card Image',
                        uploadedFileNameNotifier: instituteLogoNameNotifier,
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 20.h,),
                SaveButton(onPressed: (){}),
                SizedBox(height: 40.h,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
