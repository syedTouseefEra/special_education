


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/label_value_text.dart';
import 'package:special_education/custom_widget/text_field.dart';
import 'package:special_education/utils/navigation_utils.dart';

class SendOtpView extends StatelessWidget {
  final String selectedOption;
  final TextEditingController controller;
  final Function(String) onOptionChanged;
  final VoidCallback onSendTap;

  const SendOtpView({
    super.key,
    required this.selectedOption,
    required this.controller,
    required this.onOptionChanged,
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
                text: "Change Your Password",
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.themeColor,
                fontFamily: 'DM Serif Display',
              ),
              SizedBox(height: 10.sp),

              CustomText(
                text: "For better security, replace it with a strong password",
                color: AppColors.textGrey,
              ),
              SizedBox(height: 15.sp),

              Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  radioTheme: RadioThemeData(
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: "mobile",
                          groupValue: selectedOption,
                          activeColor: AppColors.themeColor,
                          onChanged: (value) {
                            if (value != null) onOptionChanged(value);
                          },
                        ),
                        Expanded(
                          child: LabelValueText(
                            isRow: true,
                            label: "Send OTP to",
                            value: "Mobile Number",
                            valueStyle: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.themeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "email",
                          groupValue: selectedOption,
                          activeColor: AppColors.themeColor,
                          onChanged: (value) {
                            // if (value != null) onOptionChanged(value);
                          },
                        ),
                        Expanded(
                          child: LabelValueText(
                            isRow: true,
                            label: "Send OTP to",
                            labelStyle: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.darkGrey.withOpacity(0.5),
                            ),
                            value: "Email Address",
                            valueStyle: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.themeColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),



              SizedBox(height: 20.sp),

              CustomText(
                text: selectedOption == "email"
                    ? "Email Address"
                    : "Mobile Number",
                fontSize: 12.sp,
              ),

              SizedBox(height: 10.sp),

              CustomTextField(
                controller: controller,
                keyboardType: selectedOption == "email"
                    ? TextInputType.emailAddress
                    : TextInputType.number,
                label: selectedOption == "email"
                    ? "Enter Your Email Address"
                    : "Enter Your Mobile Number",
                labelFontSize: 12.sp,
                fontSize: 15.sp,
                fontColor: AppColors.darkGrey,
                maxLength: selectedOption == "email" ? 50 : 10,
                isEmail: selectedOption == "email",
                borderRadius: 1.sp,
                borderColor: AppColors.grey,
              ),

              SizedBox(height: 60.sp),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// CANCEL
                  InkWell(
                    splashColor: AppColors.transparent,
                    highlightColor: AppColors.transparent,
                    onTap: (){
                      NavigationHelper.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.transparent,
                        border: Border.all(
                          color: AppColors.themeColor,
                          width: 0.7.sp,
                        ),
                        borderRadius: BorderRadius.circular(5.sp),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.sp, horizontal: 30.sp),
                        child: Center(
                            child: CustomText(
                              text: "Cancel",
                              color: AppColors.themeColor,
                            )),
                      ),
                    ),
                  ),

                  /// SEND OTP
                  GestureDetector(
                    onTap: () {
                      if (controller.text.isNotEmpty){

                        onSendTap();
                      }else{
                        showSnackBar("Please enter mobile number", context);
                      }

                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.themeColor,
                        borderRadius: BorderRadius.circular(5.sp),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 5.sp, horizontal: 25.sp),
                        child: Center(
                            child: CustomText(
                              text: "Send OTP",
                              color: AppColors.white,
                            )),
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
