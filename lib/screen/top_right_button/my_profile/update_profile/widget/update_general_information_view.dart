import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_dropdown_form_field.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/field_label_row.dart';
import 'package:special_education/custom_widget/text_field.dart';

class UpdateGeneralInformationView extends StatefulWidget {
  const UpdateGeneralInformationView({super.key});

  @override
  State<UpdateGeneralInformationView> createState() =>
      _UpdateGeneralInformationViewState();
}

class _UpdateGeneralInformationViewState
    extends State<UpdateGeneralInformationView> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController empIdController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  var updateGender = [
    {'id': 1, 'status': "Male"},
    {'id': 2, 'status': "Female"},
    {'id': 3, 'status': "Others"},
  ];

  late String? selectedGender =
  genderController.text.isNotEmpty ? genderController.text : null;


  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    empIdController.dispose();
    dobController.dispose();
    genderController.dispose();
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
            text: "General Information",
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          Divider(thickness: 0.5.sp, color: AppColors.darkGrey),
          SizedBox(height: 10.sp),

          FieldLabel(text: "First Name", isRequired: true),
          SizedBox(height: 3.sp,),
          CustomTextField(
            fontSize: 13.sp,
            controller: firstNameController,
            borderRadius: 5.r,
            borderColor: Colors.grey,
            fillColor: Colors.grey.shade200,
            isEditable: true,
          ),
          SizedBox(height: 2.sp),

          FieldLabel(text: "Middle Name"),
          SizedBox(height: 3.sp,),
          CustomTextField(
            fontSize: 13.sp,
            controller: middleNameController,
            borderRadius: 5,
            borderColor: Colors.grey,
            fillColor: Colors.grey.shade200,
            isEditable: true,
          ),
          SizedBox(height: 2.sp),

          FieldLabel(text: "Last Name", isRequired: true),
          SizedBox(height: 3.sp,),
          CustomTextField(
            fontSize: 13.sp,
            controller: lastNameController,
            borderRadius: 5,
            borderColor: Colors.grey,
            fillColor: Colors.grey.shade200,
            isEditable: true,
          ),
          SizedBox(height: 2.sp),

          FieldLabel(text: "Mobile", isRequired: true),
          SizedBox(height: 3.sp,),
          CustomTextField(
            fontSize: 13.sp,
            controller: mobileController,
            borderRadius: 5,
            borderColor: Colors.grey,
            fillColor: Colors.grey.shade200,
            isEditable: true,
          ),
          SizedBox(height: 2.sp),

          FieldLabel(text: "Email Id", isRequired: true),
          SizedBox(height: 3.sp,),
          CustomTextField(
            fontSize: 13.sp,
            controller: emailController,
            borderRadius: 5,
            borderColor: Colors.grey,
            fillColor: Colors.grey.shade200,
            isEditable: true,
            isEmail: true,
          ),
          SizedBox(height: 2.sp),

          FieldLabel(text: "Employee ID", isRequired: true),
          SizedBox(height: 3.sp,),
          CustomTextField(
            fontSize: 13.sp,
            controller: empIdController,
            borderRadius: 5,
            borderColor: Colors.grey,
            fillColor: Colors.grey.shade200,
            isEditable: true,
          ),
          SizedBox(height: 2.sp),


          FieldLabel(text: "Date of Birth", isRequired: true),
          SizedBox(height: 3.sp,),
          CustomTextField(
            fontSize: 13.sp,
            controller: dobController,
            borderRadius: 5,
            borderColor: Colors.grey,
            fillColor: Colors.grey.shade200,
            isEditable: true,
          ),
          SizedBox(height: 2.sp),

          FieldLabel(text: "Gender", isRequired: true),
          SizedBox(height: 3.sp,),
          CustomDropdownFormField(
            items: updateGender,
            selectedValue: selectedGender,
            hintText: 'Select Gender',
            controller: genderController,
            onChanged: (value) {
              selectedGender = value;
            },
          ),
          SizedBox(height: 15.sp),


        ],
      ),
    );
  }
}
