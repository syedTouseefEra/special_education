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
          onTap: onPressed,
          child: CustomContainer(
            text: 'Add Teacher',
            fontWeight: FontWeight.w400,
            padding: 5.sp,
            innerPadding: EdgeInsets.symmetric(horizontal: 18.sp, vertical: 10.sp),
            borderRadius: 20.r,
          ),
        ),
      ],
    );
  }
}
