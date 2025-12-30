import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/constant/colors.dart';

class UpdateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const UpdateButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomContainer(
          text: 'Cancel',
          fontWeight: FontWeight.w400,
          padding: 5.sp,
          innerPadding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 5.sp),
          borderRadius: 20.r,
          borderColor: AppColors.themeColor,
          borderWidth: 1.sp,
          containerColor: AppColors.white,
          textColor: AppColors.themeColor,
          onTap: (){
            Navigator.pop(context);
          },
        ),
        SizedBox(width: 20.sp,),
        CustomContainer(
          containerColor: AppColors.green,
          text: 'Update',
          fontWeight: FontWeight.w400,
          padding: 5.sp,
          innerPadding: EdgeInsets.symmetric(horizontal: 30.sp, vertical: 7.sp),
          borderRadius: 20.r,
          onTap: onPressed,
        ),
      ],
    );
  }
}
