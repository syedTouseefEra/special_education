import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/utils/custom_function_utils.dart';
import 'package:special_education/utils/navigation_utils.dart';
import 'package:special_education/utils/text_case_utils.dart';

class CustomHeaderView extends StatelessWidget {
  final String courseName;
  final String moduleName;
  final VoidCallback? onBackTap;

  final Color? primaryColor;
  final Color? secondaryColor;

  final double? titleFontSize;

  final Color? backIconColor;

  const CustomHeaderView({
    super.key,
    required this.courseName,
    required this.moduleName,
    this.onBackTap,
    this.primaryColor,
    this.secondaryColor,
    this.titleFontSize,
    this.backIconColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasModule = moduleName.trim().isNotEmpty;
    final bool hasCourse = courseName.trim().isNotEmpty;

    String displayText = hasCourse ? courseName.trim() : "";

    if (hasCourse && hasModule) {
      displayText += " | ${moduleName.trim()}";
    } else if (!hasCourse && hasModule) {
      displayText = moduleName.trim();
    }

    final Color usedPrimaryColor = primaryColor ?? AppColors.themeColor;
    final Color? usedSecondaryColor =
    hasModule ? (secondaryColor ?? AppColors.themeColor) : null;

    final Color usedBackIconColor = backIconColor ?? usedPrimaryColor;

    final double usedFontSize = titleFontSize ?? 18.sp;

    final int? splitIndex =
    hasModule ? getTotalCharacterCount(courseName.trim()) + 2 : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.97,
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: onBackTap ?? () => NavigationHelper.pop(context),
                child: Padding(
                  padding: EdgeInsets.all(6.sp),
                  child: Icon(
                    CupertinoIcons.back,
                    size: 22.h,
                    color: usedBackIconColor,
                  ),
                ),
              ),

              SizedBox(width: 5.w),

              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.only(right: 30.w),
                    child: CustomText(
                      text: displayText.isNotEmpty ? displayText : " ",
                      fontSize: usedFontSize,
                      fontFamily: 'Dm Serif',
                      fontWeight: FontWeight.w500,
                      color: usedPrimaryColor,
                      secondaryColor: usedSecondaryColor,
                      colorSplitIndex: splitIndex,
                      textCase: TextCase.title,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
