

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';


class CustomDropdownFormField extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String? selectedValue;
  final String hintText;
  final Function(String?) onChanged;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? contentPadding;

  const CustomDropdownFormField({
    Key? key,
    required this.items,
    required this.selectedValue,
    required this.hintText,
    required this.onChanged,
    this.controller,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.sp),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.sp),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.sp),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      ),
      icon: Icon(Icons.arrow_drop_down, size: 30.sp, color: Colors.black),
      items: items.map((item) {
        final value = item['status'] as String;
        return DropdownMenuItem<String>(
          value: value,
          child: CustomText(
            fontWeight: FontWeight.w400,
            text: value,
            fontSize: 15.sp,
            color: AppColors.themeColor,
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          if (controller != null) controller!.text = value;
          onChanged(value);
        }
      },
    );
  }
}
