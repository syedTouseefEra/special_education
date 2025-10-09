import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/label_value_text.dart';
import 'package:special_education/custom_widget/text_field.dart';
import 'package:special_education/utils/navigation_utils.dart';
import 'package:special_education/utils/text_case_utils.dart';

class LongTermGoalView extends StatelessWidget {
  const LongTermGoalView({super.key});

  @override
  Widget build(BuildContext context) {
    final learningTextController = TextEditingController();
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomText(
            text: 'Add Long Term Goal Which Kid Achieve',
            fontSize: 17.sp,
            color: AppColors.textGrey,
            fontWeight: FontWeight.w400,
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    insetPadding: EdgeInsets.zero,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 450.h,
                      child: Material(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        child: Padding(
                          padding: EdgeInsets.all(20.sp),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Add Long Term Goal',
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                                color: AppColors.themeColor,
                              ),
                              CustomText(
                                text: 'Add Long Term Goal',
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: AppColors.grey,
                              ),
                              Divider(thickness: 1),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  CustomText(
                                    text: 'Long Term Goal',
                                    color: AppColors.textGrey,
                                    fontSize: 14.h,
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 10.sp,
                                    color: AppColors.themeColor,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              CustomTextField(
                                controller: learningTextController,
                                maxLines: 10,
                                borderRadius: 0,
                                borderColor: AppColors.grey,
                                height: 220.sp,
                                label: '',
                              ),
                              SizedBox(height: 40.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      NavigationHelper.pop(context);
                                    },
                                    child: CustomContainer(
                                      borderRadius: 20.r,
                                      text: 'Back',
                                      containerColor: AppColors.yellow,
                                      padding: 1,
                                      innerPadding: EdgeInsets.symmetric(
                                        vertical: 8.sp,
                                        horizontal: 35.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: CustomContainer(
              width: MediaQuery.sizeOf(context).width,
              text: '+ Add Long Term Goal',
              containerColor: AppColors.yellow,
              textAlign: TextAlign.center,
              borderRadius: 20.r,
            ),
          ),
      
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey, width: 1.sp),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 5.sp),
                  child: LabelValueText(
                    isRow: true,
                    label: "Long Term Goal 1",
                    value: ". Complete",
                    labelStyle: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.themeColor,
                    ),
                    valueStyle: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.yellow,
                    ),
                    valueCase: TextCase.title,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: Divider(thickness: 1),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
                  child: LabelValueText(
                    isRow: true,
                    label: "Goals",
                    value: "",
                    labelStyle: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey,
                    ),
                    valueStyle: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textGrey,
                    ),
                    valueCase: TextCase.title,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
                  child: LabelValueText(
                    isRow: true,
                    label: "1.",
                    value: "Recognition of Alphabets From A-L.",
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textGrey,
                    ),
                    valueStyle: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textGrey,
                    ),
                    valueCase: TextCase.title,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
                  child: LabelValueText(
                    isRow: true,
                    label: "2.",
                    value: "Free Hand Coloring In Closed Space.",
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textGrey,
                    ),
                    valueStyle: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textGrey,
                    ),
                    valueCase: TextCase.title,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
                  child: LabelValueText(
                    isRow: true,
                    label: "3.",
                    value: "Identifying Numbers From 1-5.",
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textGrey,
                    ),
                    valueStyle: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textGrey,
                    ),
                    valueCase: TextCase.title,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
                  child: LabelValueText(
                    isRow: true,
                    label: "4.",
                    value: "Draw Sleeping,Curved And Standing Line",
                    labelStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textGrey,
                    ),
                    valueStyle: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textGrey,
                    ),
                    valueCase: TextCase.title,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomContainer(
                        borderRadius: 7.r,
                        text: 'Edit',
                        containerColor: AppColors.green,
                        padding: 1,
                        innerPadding: EdgeInsets.symmetric(
                          vertical: 8.sp,
                          horizontal: 35.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
