import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
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

  @override
  void dispose() {
    nationalityController.dispose();
    aadharCardNumberController.dispose();
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

        ],
      ),
    );
  }
}
