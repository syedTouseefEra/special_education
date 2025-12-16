import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/screen/student/profile_detail/update_student_profile_detail/update_student_profile_provider.dart';
import 'package:special_education/utils/navigation_utils.dart';

class UpdatePsychoMotorAssessmentView extends StatefulWidget {
  final String id;
  const UpdatePsychoMotorAssessmentView({super.key, required this.id});

  @override
  State<UpdatePsychoMotorAssessmentView> createState() =>
      _UpdatePsychoMotorAssessmentViewState();
}

class _UpdatePsychoMotorAssessmentViewState
    extends State<UpdatePsychoMotorAssessmentView> {

  final List<String> options = const [
    'Poor',
    'Average',
    'Good',
    'Excellent',
    'Not Applicable',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UpdateStudentProfileProvider>()
          .getPsychoStudentSkillData(context, widget.id, '1');
    });
  }

  /// API ratingId → UI text
  String ratingFromId(int id) {
    switch (id) {
      case 1:
        return 'Poor';
      case 2:
        return 'Average';
      case 3:
        return 'Good';
      case 4:
        return 'Excellent';
      default:
        return 'Not Applicable';
    }
  }

  /// UI text → API ratingId
  int ratingToId(String value) {
    switch (value) {
      case 'Poor':
        return 1;
      case 'Average':
        return 2;
      case 'Good':
        return 3;
      case 'Excellent':
        return 4;
      default:
        return 0;
    }
  }

  void _submitForm(){}

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
                const CustomHeaderView(
                  courseName: "Pre Assessment",
                  moduleName: "Psycho-Motor Skill",
                ),
                Divider(thickness: 0.7.sp),
              ],
            ),
          ),
          body: Consumer<UpdateStudentProfileProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.psychoSkillData == null ||
                  provider.psychoSkillData!.isEmpty) {
                return const Center(child: Text("No data found"));
              }

              final skills = provider.psychoSkillData?.first.skillQuality ?? [];

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: skills.length,
                      itemBuilder: (context, index) {
                        final skill = skills[index];

                        /// CASE 1: Skill has children (Visual)
                        if ((skill.skillQualityParent ?? []).isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Parent title ONCE
                              Text(
                                skill.name ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),

                              /// Child sections
                              ...List.generate(
                                skill.skillQualityParent!.length,
                                    (i) {
                                  final child = skill.skillQualityParent![i];

                                  return _buildAssessmentRow(
                                    title: "${String.fromCharCode(65 + i)}. ${child.name}",
                                    groupValue: ratingFromId(child.ratingId ?? 0),
                                    onChanged: (value) {
                                      context
                                          .read<UpdateStudentProfileProvider>()
                                          .updateChildSkillRating(
                                        child.qualityParentId!,
                                        ratingToId(value!),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          );
                        }

                        /// CASE 2: Skill has NO children → show only ONE section
                        return _buildAssessmentRow(
                          title: skill.name ?? '',
                          groupValue: ratingFromId(skill.ratingId ?? 0),
                          onChanged: (value) {
                            context
                                .read<UpdateStudentProfileProvider>()
                                .updateChildSkillRating(
                              skill.qualityId!,
                              ratingToId(value!),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        splashColor: AppColors.transparent,
                        highlightColor: AppColors.transparent,
                        onTap: () {
                          NavigationHelper.pop(context);
                        },
                        child: CustomContainer(
                          borderRadius: 20.r,
                          borderColor: AppColors.yellow,
                          text: 'Back',
                          textColor: AppColors.yellow,
                          containerColor: AppColors.transparent,
                          padding: 1.sp,
                          innerPadding: EdgeInsets.symmetric(
                            vertical: 8.sp,
                            horizontal: 35.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 20.sp),
                      InkWell(
                        splashColor: AppColors.transparent,
                        highlightColor: AppColors.transparent,
                        onTap: _submitForm,
                        child: CustomContainer(
                          text: 'Save And Continue',
                          fontWeight: FontWeight.w400,
                          padding: 5.sp,
                          innerPadding: EdgeInsets.symmetric(
                            horizontal: 18.sp,
                            vertical: 8.sp,
                          ),
                          borderRadius: 20.r,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.sp),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAssessmentRow({
    required String title,
    required String groupValue,
    required Function(String?) onChanged,
  }) {
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
        SizedBox(height: 10.sp),

        Row(
          children: [
            Expanded(
              child: _radioItem('Poor', groupValue, onChanged),
            ),
            Expanded(
              child: _radioItem('Average', groupValue, onChanged),
            ),
          ],
        ),

        SizedBox(height: 5.sp),

        Row(
          children: [
            Expanded(
              child: _radioItem('Good', groupValue, onChanged),
            ),
            Expanded(
              child: _radioItem('Excellent', groupValue, onChanged),
            ),
          ],
        ),

        SizedBox(height: 5.sp),

        Row(
          children: [
            Expanded(
              child: _radioItem('Not Applicable', groupValue, onChanged),
            ),
          ],
        ),

        const Divider(height: 32),
      ],
    );
  }


  Widget _radioItem(
      String value,
      String groupValue,
      Function(String?) onChanged,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }



}
