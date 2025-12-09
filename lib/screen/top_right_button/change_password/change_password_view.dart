import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/text_field.dart';
import 'package:special_education/utils/navigation_utils.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void onChangeTap() {
    if (newPasswordController.text.trim() != confirmPasswordController.text.trim()) {
      showSnackBar("Passwords do not match", context);
      return;
    }

    showSnackBar("Password changed successfully!", context, success: true);

    print("Change Password Clicked");
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(height: 15.sp),
              CustomHeaderView(courseName: '', moduleName: "Change Password"),
              Divider(thickness: 1.sp,),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 20.sp),
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

                    CustomText(text: "Old Password", fontSize: 12.sp),
                    SizedBox(height: 10.sp),
                    CustomTextField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      label: "Enter Password",
                      labelFontSize: 12.sp,
                      fontSize: 15.sp,
                      fontColor: AppColors.darkGrey,
                      maxLength: 50,
                      borderRadius: 5.sp,
                      onlyLettersAndNumbers: true,
                      borderColor: AppColors.grey,
                    ),

                    SizedBox(height: 15.sp),

                    CustomText(text: "New Password", fontSize: 12.sp),
                    SizedBox(height: 10.sp),
                    CustomTextField(
                      controller: newPasswordController,
                      keyboardType: TextInputType.text,
                      label: "Enter New Password",
                      labelFontSize: 12.sp,
                      fontSize: 15.sp,
                      fontColor: AppColors.darkGrey,
                      maxLength: 50,
                      onlyLettersAndNumbers: true,
                      borderRadius: 5.sp,
                      borderColor: AppColors.grey,
                    ),

                    SizedBox(height: 15.sp),

                    CustomText(text: "Confirm Password", fontSize: 12.sp),
                    SizedBox(height: 10.sp),
                    CustomTextField(
                      controller: confirmPasswordController,
                      keyboardType: TextInputType.text,
                      label: "Confirm Password",
                      labelFontSize: 12.sp,
                      fontSize: 15.sp,
                      fontColor: AppColors.darkGrey,
                      maxLength: 50,
                      onlyLettersAndNumbers: true,
                      borderRadius: 5.sp,
                      borderColor: AppColors.grey,
                    ),

                    SizedBox(height: 40.sp),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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

                        /// Change Password Button
                        GestureDetector(
                          onTap: onChangeTap,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.themeColor,
                              borderRadius: BorderRadius.circular(5.sp),
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
            ],
          ),
        ),
      ),
    );
  }
}
