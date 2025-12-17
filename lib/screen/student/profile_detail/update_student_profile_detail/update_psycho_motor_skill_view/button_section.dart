import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/utils/navigation_utils.dart';

class ButtonSection extends StatelessWidget {
  final VoidCallback submitForm;
  const ButtonSection({super.key, required this.submitForm});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () => NavigationHelper.pop(context),
            child: CustomContainer(
              borderRadius: 20.r,
              borderColor: AppColors.yellow,
              text: 'Back',
              textColor: AppColors.yellow,
              containerColor: Colors.transparent,
              innerPadding: EdgeInsets.symmetric(
                vertical: 8.sp,
                horizontal: 35.sp,
              ),
            ),
          ),
          SizedBox(width: 20.sp),
          InkWell(
            onTap: submitForm,
            child: CustomContainer(
              text: 'Save And Continue',
              borderRadius: 20.r,
              innerPadding: EdgeInsets.symmetric(
                vertical: 8.sp,
                horizontal: 18.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
