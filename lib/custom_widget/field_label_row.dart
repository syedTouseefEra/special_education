// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:special_education/custom_widget/custom_text.dart';
//
// class FieldLabel extends StatelessWidget {
//   final String text;
//   final bool isRequired;
//   final Color? color;
//   final double? fontSize;
//
//   const FieldLabel({
//     super.key,
//     required this.text,
//     this.isRequired = false,
//     this.color,
//     this.fontSize,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CustomText(text: text,color: color ?? Colors.grey.shade600,
//           fontSize: fontSize ?? 12.h,),
//
//         if (isRequired)
//           Padding(
//             padding: EdgeInsets.only(left: 2.w, top: 2.h),
//             child: Icon(
//               Icons.star_purple500_sharp,
//               color: Colors.red,
//               size: 8.sp,
//             ),
//           ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';

class FieldLabel extends StatelessWidget {
  final String text;
  final bool isRequired;

  /// New: show/hide leading icon
  final bool showLeadingIcon;

  final Color? color;
  final double? fontSize;

  const FieldLabel({
    super.key,
    required this.text,
    this.isRequired = false,
    this.showLeadingIcon = false,   // default ON
    this.color,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Leading icon only if enabled
        if (showLeadingIcon)
          Icon(
            Icons.error_outline,
            size: 12.sp,
            color: AppColors.yellow,
          ),

        if (showLeadingIcon) SizedBox(width: 4.w),

        /// Label text
        CustomText(
          text: text,
          color: color ?? Colors.grey.shade600,
          fontSize: fontSize ?? 12.h,
        ),

        /// Required icon
        if (isRequired)
          Padding(
            padding: EdgeInsets.only(left: 2.w, top: 2.h),
            child: Icon(
              Icons.star_purple500_sharp,
              color: Colors.red,
              size: 8.sp,
            ),
          ),
      ],
    );
  }
}

