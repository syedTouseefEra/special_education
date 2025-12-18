

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
    return SizedBox(
      height: 35.sp,
      child: DropdownButtonFormField<String>(
        // if empty string, treat as null so hint shows
        value: (selectedValue == null || selectedValue!.isEmpty)
            ? null
            : selectedValue,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
          contentPadding: contentPadding ??
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
        ),
        // <-- use this for the placeholder
        hint: CustomText(
          fontWeight: FontWeight.w400,
          text: hintText,
          fontSize: 13.sp,
          color: AppColors.grey,
        ),
        icon: Icon(Icons.keyboard_arrow_down, size: 22.sp, color: Colors.black),
        items: items.map((item) {
          final value = item['status'] as String;
          return DropdownMenuItem<String>(
            value: value,
            child: CustomText(
              fontWeight: FontWeight.w400,
              text: value,
              fontSize: 13.sp,
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
      ),
    );
  }
}

