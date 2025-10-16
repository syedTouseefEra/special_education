
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
  final int? maxLength;
  final bool? must;
  final bool isEmail;
  final bool isMobile;
  final bool onlyLetters;
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

  const CustomTextField({
    super.key,
    required this.controller,
    this.label,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.maxLength,
    this.must,
    this.isEmail = false,
    this.isMobile = false,
    this.onlyLetters = false,
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
    } else {
      setState(() => errorText = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color effectiveBorderColor =
        widget.borderColor ?? AppColors.themeBlue;
    final double effectiveBorderRadius = widget.borderRadius ?? 30.sp;

    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            validateInput();
          }
        },
        child: SizedBox(
          height: widget.height ?? 50.h,
          child: TextField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            maxLines: widget.maxLines ?? 1,
            maxLength: widget.maxLength,
            readOnly: !widget.isEditable,
            textAlignVertical: widget.maxLines != null && widget.maxLines! > 1
                ? TextAlignVertical.top
                : TextAlignVertical.center,
            style: TextStyle(
              fontSize: widget.fontSize ?? 14.sp,
              color: widget.isEditable
                  ? (widget.fontColor ?? AppColors.themeBlue)
                  : AppColors.darkGrey,
            ),
            inputFormatters: widget.onlyLetters
                ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
            ]
                : null,
            contextMenuBuilder: (context, editableTextState) {
              return widget.isEditable
                  ? AdaptiveTextSelectionToolbar.editableText(
                editableTextState: editableTextState,
              )
                  : const SizedBox.shrink();
            },
            onChanged: widget.onChanged,
            onTap: widget.onTap,// this line passes onChanged callback
            decoration: InputDecoration(
              counterText: "",
              labelText: widget.label,
              labelStyle: TextStyle(
                color: AppColors.grey,
                fontSize: widget.fontSize ?? 14.sp,
              ),
              suffixIcon: widget.suffixIcon,
              errorText: errorText,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: widget.maxLines != null && widget.maxLines! > 1
                    ? 16.h
                    : 10.h,
                horizontal: 10.w,
              ),
              filled: widget.fillColor != null,
              fillColor: widget.fillColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 30.sp),
                borderSide: BorderSide(color: widget.borderColor ?? AppColors.themeBlue),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 30.sp),
                borderSide: BorderSide(color: widget.borderColor ?? AppColors.themeBlue, width: 1.w),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 30.sp),
                borderSide: const BorderSide(color: AppColors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 30.sp),
                borderSide: const BorderSide(color: AppColors.red, width: 1),
              ),
            ),
          )
        ),
      ),
    );
  }
}
