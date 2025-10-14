
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/utils/custom_function_utils.dart';
import 'package:special_education/utils/navigation_utils.dart';
import 'package:special_education/utils/text_case_utils.dart';

class CustomHeaderView extends StatelessWidget {
  final String courseName;
  final String moduleName;
  final VoidCallback? onBackTap;

  const CustomHeaderView({
    super.key,
    required this.courseName,
    required this.moduleName,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isModuleNameEmpty = moduleName.isEmpty;
    String displayText = courseName;
    if (!isModuleNameEmpty) {
      displayText += " | $moduleName";
    }

    Color primaryColor = isModuleNameEmpty ? AppColors.themeColor : AppColors.headerGrey;
    Color? secondaryColor = isModuleNameEmpty ? null : AppColors.themeColor;
    int? colorSplitIndexValue = isModuleNameEmpty ? null : getTotalCharacterCount(courseName) + 2;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15.sp),
        SizedBox(
          width: MediaQuery.sizeOf(context).width / 1.05,
          child: Row(
            children: [
              InkWell(
                onTap: onBackTap ??
                        () {
                      NavigationHelper.pop(context);
                    },
                child: Icon(CupertinoIcons.back,size: 22.h,color:
                  AppColors.themeColor,),
              ),
              SizedBox(width: 5.sp),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                      padding: EdgeInsets.only(right: 30.sp),
                      child: CustomText(
                        color: primaryColor,
                        secondaryColor: secondaryColor,
                        colorSplitIndex: colorSplitIndexValue,
                        text: displayText,
                        fontSize: 18.h,
                        fontFamily: 'Dm Serif',
                        fontWeight: FontWeight.w500,
                        textCase: TextCase.title,
                      )),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),

      ],
    );
  }
}
