import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';

class PsychoMotorAssessmentView extends StatefulWidget {
  const PsychoMotorAssessmentView({Key? key}) : super(key: key);

  @override
  State<PsychoMotorAssessmentView> createState() =>
      _PsychoMotorAssessmentViewState();
}

class _PsychoMotorAssessmentViewState
    extends State<PsychoMotorAssessmentView> {
  final List<String> options = [
    'Poor',
    'Average',
    'Good',
    'Excellent',
    'Not Applicable',
  ];

  final Map<String, String?> selectedValues = {
    'Gross Motor': null,
    'Fine Motor': null,
    'Sitting': null,
    'Sitting Posture': null,
    'Speech': null,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.sp),
            child: Column(
                children: [
                  SizedBox(height: 5.sp),
                  CustomHeaderView(courseName: "Pre Assessment", moduleName: "Psycho-Motor Skill"),
                  Divider(thickness: 0.7.sp),
                ]
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: selectedValues.keys.map((title) {
                return _buildAssessmentRow(title);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssessmentRow(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 20,
          runSpacing: 8,
          children: options.map((option) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: option,
                  groupValue: selectedValues[title],
                  activeColor: Colors.pink,
                  onChanged: (value) {
                    setState(() {
                      selectedValues[title] = value;
                    });
                  },
                ),
                Text(option),
              ],
            );
          }).toList(),
        ),
        const Divider(height: 32),
      ],
    );
  }
}
