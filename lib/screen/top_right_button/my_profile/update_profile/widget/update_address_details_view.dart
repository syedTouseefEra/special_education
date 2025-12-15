import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/field_label_row.dart';
import 'package:special_education/custom_widget/text_field.dart';

class UpdateAddressDetailsView extends StatefulWidget {
  const UpdateAddressDetailsView({super.key});

  @override
  State<UpdateAddressDetailsView> createState() =>
      _UpdateAddressDetailsViewState();
}

class _UpdateAddressDetailsViewState
    extends State<UpdateAddressDetailsView> {
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityTownController = TextEditingController();

  @override
  void dispose() {
    pincodeController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    countryController.dispose();
    stateController.dispose();
    cityTownController.dispose();
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
            text: "Address Details",
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          Divider(thickness: 0.5.sp, color: AppColors.darkGrey),
          SizedBox(height: 10.sp),

          FieldLabel(text: "Pincode"),
          SizedBox(height: 3.sp,),
          CustomTextField(
            fontSize: 13.sp,
            controller: pincodeController,
            borderRadius: 5.r,
            borderColor: Colors.grey,
            fillColor: Colors.grey.shade200,
            isEditable: true,
          ),
          SizedBox(height: 2.sp),

          FieldLabel(text: "Address Line 1"),
          SizedBox(height: 3.sp,),
          CustomTextField(
            fontSize: 13.sp,
            controller: addressLine1Controller,
            borderRadius: 5,
            borderColor: Colors.grey,
            fillColor: Colors.grey.shade200,
            isEditable: true,
          ),
          SizedBox(height: 2.sp),

          FieldLabel(text: "Address Line 2"),
          SizedBox(height: 3.sp,),
          CustomTextField(
            fontSize: 13.sp,
            controller: addressLine2Controller,
            borderRadius: 5,
            borderColor: Colors.grey,
            fillColor: Colors.grey.shade200,
            isEditable: true,
          ),
          SizedBox(height: 2.sp),

          FieldLabel(text: "Country", isRequired: true),
          SizedBox(height: 3.sp,),
          CustomTextField(
            fontSize: 13.sp,
            controller: countryController,
            borderRadius: 5,
            borderColor: Colors.grey,
            fillColor: Colors.grey.shade200,
            isEditable: true,
          ),
          SizedBox(height: 2.sp),

          FieldLabel(text: "State", isRequired: true),
          SizedBox(height: 3.sp,),
          CustomTextField(
            fontSize: 13.sp,
            controller: stateController,
            borderRadius: 5,
            borderColor: Colors.grey,
            fillColor: Colors.grey.shade200,
            isEditable: true,
            isEmail: true,
          ),
          SizedBox(height: 2.sp),

          FieldLabel(text: "City/Town", isRequired: true),
          SizedBox(height: 3.sp,),
          CustomTextField(
            fontSize: 13.sp,
            controller: cityTownController,
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
