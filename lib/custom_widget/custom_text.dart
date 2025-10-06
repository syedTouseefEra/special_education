
import 'package:flutter/material.dart';
import 'package:special_education/utils/text_case_utils.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final Color? secondaryColor;
  final int? colorSplitIndex;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextCase? textCase;
  final String? fontFamily;
  final bool isUnderlined;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.secondaryColor,
    this.colorSplitIndex,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.textCase,
    this.fontFamily,
    this.isUnderlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final styledText = applyTextCase(text, textCase);

    final shouldUseTwoColors = secondaryColor != null &&
        colorSplitIndex != null &&
        colorSplitIndex! > 0 &&
        colorSplitIndex! < styledText.length;

    if (!shouldUseTwoColors) {
      return Text(
        styledText,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontFamily: fontFamily ?? 'Inter',
          decoration: isUnderlined ? TextDecoration.underline : TextDecoration.none,
        ),
      );
    }

    final firstPart = styledText.substring(0, colorSplitIndex);
    final secondPart = styledText.substring(colorSplitIndex!);

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: firstPart,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: color,
              fontFamily: fontFamily ?? 'Inter',
              decoration: isUnderlined ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
          TextSpan(
            text: secondPart,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: secondaryColor,
              fontFamily: fontFamily ?? 'Inter',
              decoration: isUnderlined ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ],
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

String truncateText(String text, int maxLength) {
  if (text.isEmpty) return '';

  String trimmed = text.trim();

  // Truncate safely
  if (trimmed.length > maxLength) {
    trimmed = trimmed.substring(0, maxLength);
  }

  // Convert to sentence case
  final buffer = StringBuffer();
  bool capitalizeNext = true;

  for (int i = 0; i < trimmed.length; i++) {
    String char = trimmed[i];

    if (capitalizeNext && RegExp(r'[a-zA-Z]').hasMatch(char)) {
      buffer.write(char.toUpperCase());
      capitalizeNext = false;
    } else {
      buffer.write(char);
    }

    if (char == '.') {
      capitalizeNext = true;
    }
  }

  return buffer.toString();
}

class NameUtils {
  static String getFullName({
    required String? firstName,
    required String? middleName,
    required String? lastName,
  }) {
    final fName = firstName?.trim();
    final mName = middleName?.trim();
    final lName = lastName?.trim();

    final nameParts = [fName, mName, lName]
        .where((part) => part != null && part.isNotEmpty)
        .toList();

    return nameParts.join(" ");
  }
}
