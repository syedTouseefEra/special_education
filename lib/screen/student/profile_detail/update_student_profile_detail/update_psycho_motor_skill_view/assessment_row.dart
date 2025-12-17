import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssessmentRowWidget extends StatelessWidget {
  final String title;
  final String groupValue;
  final Function(String?) onChanged;
  final bool isParent;

  const AssessmentRowWidget({
    super.key,
    required this.title,
    required this.groupValue,
    required this.onChanged,
    this.isParent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isParent ? 15.sp : 14.sp,
            fontWeight: isParent ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        SizedBox(height: 10.sp),
        Row(
          children: [
            Expanded(child: _radioItem('Poor')),
            Expanded(child: _radioItem('Average')),
          ],
        ),
        SizedBox(height: 5.sp),
        Row(
          children: [
            Expanded(child: _radioItem('Good')),
            Expanded(child: _radioItem('Excellent')),
          ],
        ),
        SizedBox(height: 5.sp),
        _radioItem('Not Applicable'),
        const Divider(height: 32),
      ],
    );
  }

  Widget _radioItem(String value) {
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
