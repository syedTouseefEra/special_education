

import 'package:flutter/Material.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/utils/text_case_utils.dart';

class CustomContainer extends StatelessWidget {
  final double padding;
  final EdgeInsets innerPadding;
  final Color containerColor;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final String text;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextCase? textCase;
  final String? fontFamily;
  final int? maxLines;
  final TextOverflow? overflow;

  const CustomContainer({
    super.key,
    this.padding = 15.0,
    this.innerPadding = const EdgeInsets.all(10.0),
    this.containerColor = Colors.orange,
    this.borderRadius = 5.0,
    this.borderWidth = 0.0,
    this.borderColor = Colors.transparent,
    this.text = "Educational Development",
    this.textColor = AppColors.white,
    this.fontSize = 15.0,
    this.fontWeight = FontWeight.w600,
    this.textAlign = TextAlign.start,
    this.textCase = TextCase.sentence,
    this.fontFamily,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Container(
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            width: borderWidth,
            color: borderColor,
          ),
        ),
        child: Padding(
          padding: innerPadding,
          child: CustomText(
            text: text,
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
            textAlign: textAlign,
            textCase: textCase,
            fontFamily: fontFamily,
            maxLines: maxLines,
            overflow: overflow,
          ),
        ),
      ),
    );
  }
}
