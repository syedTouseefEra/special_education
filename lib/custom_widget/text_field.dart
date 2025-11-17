import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLength;
  final bool? must;
  final bool isEmail;
  final bool isMobile;
  final bool onlyLetters;
  final bool onlyLettersAndNumbers; // ✅ New property
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

  const CustomTextField({
    super.key,
    required this.controller,
    this.label,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
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
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? errorText;

  bool isValidEmail(String email) {
    final emailRegex =
    RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  bool isValidMobile(String mobile) {
    final mobileRegex = RegExp(r"^[0-9]{10}$");
    return mobileRegex.hasMatch(mobile);
  }

  bool isOnlyLetters(String input) {
    final lettersRegex = RegExp(r'^[a-zA-Z\s]*$');
    return lettersRegex.hasMatch(input);
  }

  bool isOnlyLettersAndNumbers(String input) {
    final regex = RegExp(r'^[a-zA-Z0-9\s]*$');
    return regex.hasMatch(input);
  }

  void validateInput() {
    final text = widget.controller.text.trim();

    if (widget.isEmail) {
      if (text.isEmpty || isValidEmail(text)) {
        setState(() => errorText = null);
      } else {
        setState(() => errorText = 'Invalid email address');
      }
    } else if (widget.isMobile) {
      if (text.isEmpty || isValidMobile(text)) {
        setState(() => errorText = null);
      } else {
        setState(() => errorText = 'Invalid mobile number');
      }
    } else if (widget.onlyLetters) {
      if (text.isEmpty || isOnlyLetters(text)) {
        setState(() => errorText = null);
      } else {
        setState(() => errorText = 'Only letters are allowed');
      }
    } else if (widget.onlyLettersAndNumbers) {
      if (text.isEmpty || isOnlyLettersAndNumbers(text)) {
        setState(() => errorText = null);
      } else {
        setState(() => errorText = 'Only letters and numbers are allowed');
      }
    } else {
      setState(() => errorText = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.sp,
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            validateInput();
          }
        },
        child: TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          maxLines: 1,
          maxLength: widget.maxLength,
          readOnly: !widget.isEditable,

          style: TextStyle(
            fontSize: widget.fontSize ?? 15.sp,
            color: widget.isEditable
                ? (widget.fontColor ?? AppColors.themeBlue)
                : AppColors.darkGrey,
          ),

          inputFormatters: widget.onlyLetters
              ? [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))]
              : widget.onlyLettersAndNumbers
              ? [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]'))]
              : null,

          onChanged: widget.onChanged,
          onTap: widget.onTap,
          validator: widget.validator,

          decoration: InputDecoration(
            counterText: "",
            labelText: widget.label,
            alignLabelWithHint: false,

            labelStyle: TextStyle(
              color: AppColors.grey,
              fontSize: widget.fontSize ?? 16.sp,
            ),
            floatingLabelStyle: TextStyle(
              fontSize: 13.sp,
              color: AppColors.darkGrey,
            ),


            prefixIcon: widget.prefixIcon,

            prefixIconConstraints: BoxConstraints(
              minWidth: 40.sp,
              minHeight: 40.sp,
            ),

            suffixIcon: widget.suffixIcon,
            errorText: errorText,

            helperText: null,
            isDense: true,

            contentPadding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 12.sp,
            ),

            filled: widget.fillColor != null,
            fillColor: widget.fillColor,

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 30),
              borderSide: BorderSide(color: widget.borderColor ?? AppColors.themeBlue),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 30),
              borderSide: BorderSide(color: widget.borderColor ?? AppColors.themeBlue),
            ),
          ),
        ),
      ),
    );

  }
}
