


import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';

class OptionItem extends StatelessWidget {
  final int value;
  final String label;
  final int selected;
  final VoidCallback onTap;

  const OptionItem({
    super.key,
    required this.value,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            selected == value
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: AppColors.themeColor,
            size: 18.sp,
          ),
          SizedBox(width: 6.sp),
          CustomText(text: label),
        ],
      ),
    );
  }
}
