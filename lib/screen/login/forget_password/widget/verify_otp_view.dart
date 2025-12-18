


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/screen/login/forget_password/widget/otp_fields_view.dart';

class VerifyOtpView extends StatelessWidget {
  final String selectedOption;
  final TextEditingController controller;
  final Function(String) onOptionChanged;
  final VoidCallback setStep;
  final VoidCallback onSendTap;

  const VerifyOtpView({
    super.key,
    required this.selectedOption,
    required this.controller,
    required this.onOptionChanged,
    required this.setStep,
    required this.onSendTap,
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
                text: "Verify Your Mobile Number!",
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.themeColor,
                fontFamily: 'DM Serif Display',
              ),
              SizedBox(height: 10.sp),
              CustomText(
                text:
                "For a purpose of institute regulation, your details are required",
                color: AppColors.textGrey,
              ),
              SizedBox(height: 15.sp),


              SizedBox(height: 20.sp),

              CustomText(
                text: "Mobile Number",
                fontSize: 12.sp,
              ),
              SizedBox(height: 10.sp),

              /// OTP boxes
              OtpFields(
                length: 6,
                onChanged: (value) {
                  controller.text = value;   // store the full OTP in your controller
                },
              ),


              SizedBox(height: 60.sp),

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
                              vertical: 5.sp, horizontal: 30.sp),
                          child: Center(
                            child: CustomText(
                              text: "Cancel",
                              color: AppColors.themeColor,
                            ),
                          ),
                        ),
                      ),
                   ),


                  /// VERIFY OTP
                  GestureDetector(
                    onTap: onSendTap,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.themeColor,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.sp, horizontal: 25.sp),
                        child: Center(
                          child: CustomText(
                            text: "Verify OTP",
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


