import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/custom_widget/field_label_row.dart';
import 'package:special_education/custom_widget/text_field.dart';
import 'package:special_education/constant/colors.dart';

class FormTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isRequired;

  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final int? maxLength;
  final bool? must;
  final bool isEmail;
  final bool isMobile;
  final bool onlyLetters;
  final bool onlyLettersAndNumbers;
  final Color? borderColor;
  final double? borderRadius;
  final double? fontSize;
  final Color? fontColor;
  final double? height;
  final int? maxLines;
  final Color? fillColor;
  final bool isEditable;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;

  const FormTextField({
    super.key,
    required this.label,
    required this.controller,
    this.isRequired = false,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.maxLength,
    this.must,
    this.isEmail = false,
    this.isMobile = false,
    this.onlyLetters = false,
    this.onlyLettersAndNumbers = false,
    this.borderColor,
    this.borderRadius,
    this.fontSize,
    this.fontColor,
    this.height,
    this.maxLines,
    this.fillColor,
    this.isEditable = true,
    this.onChanged,
    this.onTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(
          text: label,
          isRequired: isRequired,
          fontSize: fontSize ?? 14.sp,
          color: AppColors.black,
        ),
        SizedBox(height: 5.sp),
        CustomTextField(
          controller: controller,
          label: 'Enter $label',
          obscureText: obscureText,
          keyboardType: keyboardType,
          suffixIcon: suffixIcon,
          maxLength: maxLength,
          must: must,
          isEmail: isEmail,
          isMobile: isMobile,
          onlyLetters: onlyLetters,
          onlyLettersAndNumbers: onlyLettersAndNumbers,
          borderColor: borderColor ?? AppColors.grey,
          borderRadius: borderRadius ?? 8.r,
          fontSize: fontSize,
          fontColor: fontColor,
          height: height,
          maxLines: maxLines,
          fillColor: fillColor,
          isEditable: isEditable,
          onChanged: onChanged,
          onTap: onTap,
          validator: validator,
        ),
      ],
    );
  }
}
