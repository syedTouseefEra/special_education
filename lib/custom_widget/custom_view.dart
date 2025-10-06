import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/assets.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_text.dart';

class CustomViewCard extends StatelessWidget {
  const CustomViewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.sp, 15.sp, 10.sp, 0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor, width: 1.sp),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 70.sp,
                width: 70.sp,
                decoration: BoxDecoration(
                  color: AppColors.themeColor,
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(ImgAssets.user,),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(width: 10.sp),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Syed Touseef",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.themeColor, // Pink/red color
                  ),
                  SizedBox(height: 2.sp),
                  CustomText(
                    text: "PID - 10120",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGrey,
                  ),
                  SizedBox(height: 2.sp),
                  CustomText(
                    text: "Diagnosis - GDD",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGrey,
                  ),
                ],
              ),
            ],
          ),

          Align(
            alignment: Alignment.centerRight,
            child: CustomContainer(
              text: 'View',
              innerPadding: EdgeInsets.symmetric(
                vertical: 4.sp,
                horizontal: 20.sp,
              ),
              containerColor: Colors.white,
              textColor: AppColors.yellow,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              borderColor: AppColors.yellow,
              borderWidth: 1,
            ),
          ),
        ],
      ),
    );
  }
}
