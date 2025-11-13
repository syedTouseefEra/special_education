import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/constant/colors.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveButton({super.key, required this.onPressed});

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
            innerPadding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 5.sp),
            borderRadius: 20.r,
            borderColor: AppColors.themeColor,
            borderWidth: 1.sp,
            containerColor: AppColors.white,
            textColor: AppColors.themeColor,
          ),
        ),
        SizedBox(width: 20.sp,),
        InkWell(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
          onTap: onPressed,
          child: CustomContainer(
            containerColor: AppColors.green,
            text: 'Update',
            fontWeight: FontWeight.w400,
            padding: 5.sp,
            innerPadding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 7.sp),
            borderRadius: 20.r,
          ),
        ),
      ],
    );
  }
}
