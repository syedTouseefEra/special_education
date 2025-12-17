import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/screen/student/profile_detail/update_student_profile_detail/update_psycho_motor_skill_view/assessment_row.dart';
import 'package:special_education/screen/student/profile_detail/update_student_profile_detail/update_psycho_motor_skill_view/button_section.dart';
import 'package:special_education/screen/student/profile_detail/update_student_profile_detail/update_psycho_motor_skill_view/custom_header_section.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<UpdateStudentProfileProvider>()
          .getPsychoStudentSkillData(context, widget.id, '1');
    });
  }

  void _submitForm() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: const CustomHeaderSection(),
          body: Consumer<UpdateStudentProfileProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final skills =
                  provider.psychoSkillData?.first.skillQuality ?? [];

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: skills.length,
                      itemBuilder: (context, index) {
                        final skill = skills[index];

                        if ((skill.skillQualityParent ?? []).isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: '${index + 1}. ${skill.name ?? ''}',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(height: 12.sp),

                              /// Children
                              ...List.generate(
                                skill.skillQualityParent!.length,
                                    (i) {
                                  final child =
                                  skill.skillQualityParent![i];
                                  return AssessmentRowWidget(
                                    title:
                                    '${String.fromCharCode(65 + i)}. ${child.name}',
                                    groupValue:
                                    ratingFromId(child.ratingId ?? 0),
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

                        return AssessmentRowWidget(
                          title: '${index + 1}. ${skill.name ?? ''}',
                          isParent: true,
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

                  ButtonSection(submitForm: _submitForm),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

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
}
