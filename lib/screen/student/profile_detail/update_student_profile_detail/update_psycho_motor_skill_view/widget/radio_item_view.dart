import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RadioItemView extends StatelessWidget {
  final String value;
  final String groupValue;
  final Function(String?) onChanged;

  const RadioItemView({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          activeColor: Colors.pink,
          onChanged: onChanged,
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 13.sp),
          ),
        ),
      ],
    );
  }
}
