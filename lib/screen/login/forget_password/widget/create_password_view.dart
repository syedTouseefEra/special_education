import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/text_field.dart';

class CreatePasswordView extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback setStep;
  final VoidCallback onChangeTap;

  const CreatePasswordView({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.setStep,
    required this.onChangeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.sp),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey, width: 0.7.sp),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Create A New Password!",
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.themeColor,
                fontFamily: 'DM Serif Display',
              ),
              SizedBox(height: 10.sp),

              CustomText(
                text:
                "Create a password that includes letters, numbers, and special characters.",
                color: AppColors.textGrey,
              ),
              SizedBox(height: 20.sp),

              CustomText(
                text: "New Password",
                fontSize: 12.sp,
              ),
              SizedBox(height: 10.sp),

              CustomTextField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                label: "Enter Password",
                labelFontSize: 12.sp,
                fontSize: 15.sp,
                fontColor: AppColors.darkGrey,
                maxLength: 50,
                isEmail: false,
                borderRadius: 5.sp,
                borderColor: AppColors.grey,
              ),

              SizedBox(height: 15.sp),

              CustomText(
                text: "Confirm Password",
                fontSize: 12.sp,
              ),
              SizedBox(height: 10.sp),

              CustomTextField(
                controller: confirmPasswordController,
                keyboardType: TextInputType.text,
                label: "Confirm Password",
                labelFontSize: 12.sp,
                fontSize: 15.sp,
                fontColor: AppColors.darkGrey,
                maxLength: 50,
                isEmail: false,
                borderRadius: 5.sp,
                borderColor: AppColors.grey,
              ),

              SizedBox(height: 40.sp),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: setStep,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.transparent,
                        border: Border.all(
                          color: AppColors.themeColor,
                          width: 0.7.sp,
                        ),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.sp,
                          horizontal: 42.sp,
                        ),
                        child: Center(
                          child: CustomText(
                            text: "Cancel",
                            color: AppColors.themeColor,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Change password
                  GestureDetector(
                    onTap: onChangeTap,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.themeColor,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.sp,
                          horizontal: 15.sp,
                        ),
                        child: Center(
                          child: CustomText(
                            text: "Change Password",
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.sp),
            ],
          ),
        ),
      ),
    );
  }
}
