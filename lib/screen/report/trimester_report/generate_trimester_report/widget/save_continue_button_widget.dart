import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/constant/colors.dart';

class SaveContinueButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveContinueButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
          onTap: (){
            Navigator.pop(context);
          },
          child: CustomContainer(
            text: 'Cancel',
            fontWeight: FontWeight.w400,
            padding: 5.sp,
            innerPadding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 7.sp),
            borderRadius: 20.r,
            fontSize: 13.sp,
            borderColor: AppColors.yellow,
            borderWidth: 1.sp,
            containerColor: AppColors.white,
            textColor: AppColors.yellow,
          ),
        ),
        SizedBox(width: 10.sp,),
        InkWell(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
          onTap: onPressed,
          child: CustomContainer(
            containerColor: AppColors.yellow,
            text: 'Save And Continue',
            fontWeight: FontWeight.w400,
            fontSize: 13.sp,
            padding: 5.sp,
            innerPadding: EdgeInsets.symmetric(horizontal: 18.sp, vertical: 8.sp),
            borderRadius: 20.r,
          ),
        ),
      ],
    );
  }
}
