import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FieldLabel extends StatelessWidget {
  final String text;
  final bool isRequired;
  final Color? color;
  final double? fontSize;

  const FieldLabel({
    super.key,
    required this.text,
    this.isRequired = false,
    this.color,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            color: color ?? Colors.grey.shade600,
            fontSize: fontSize ?? 12.h,
          ),
        ),
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
