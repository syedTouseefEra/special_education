import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/custom_widget/custom_text.dart';
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

  void _submitForm() {
    final provider = Provider.of<UpdateStudentProfileProvider>(context, listen: false);
    final skills = provider.psychoSkillData?.first.skillQuality ?? [];
    final qualityText = generateQualityText(skills);

    provider.updatePsychoStudentSkillData(
      widget.id,
      "1",
      qualityText,
      context,
    );
  }

  String generateQualityText(List<dynamic> skills) {
    final List<Map<String, dynamic>> qualityList = [];

    for (var skill in skills) {
      if ((skill.skillQualityParent ?? []).isNotEmpty) {
        for (var child in skill.skillQualityParent!) {
          qualityList.add({
            "qualityId": child.qualityId,
            "qualityParentId": child.qualityParentId,
            "ratingId": child.ratingId,
            "studentSkillId": child.studentSkillId,
          });
        }
      } else {
        qualityList.add({
          "qualityId": skill.qualityId,
          "qualityParentId": 0,
          "ratingId": skill.ratingId,
          "studentSkillId": skill.studentSkillId,
        });
      }
    }

    return qualityList.isNotEmpty ? jsonEncode(qualityList) : "[]";
  }

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

                        /// ===============================
                        /// PARENT WITH CHILDREN (Visual)
                        /// ===============================
                        if ((skill.skillQualityParent ?? []).isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Parent title
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
                                  return _buildAssessmentRow(
                                    title:
                                    '${String.fromCharCode(65 + i)}. ${child.name}',
                                    groupValue:
                                    ratingFromId(child.ratingId ?? 0),
                                    onChanged: (value) {
                                      context
                                          .read<
                                          UpdateStudentProfileProvider>()
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

                        /// ===============================
                        /// PARENT WITHOUT CHILDREN (Speech)
                        /// ===============================
                        return _buildAssessmentRow(
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

                  /// Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => NavigationHelper.pop(context),
                        child: CustomContainer(
                          borderRadius: 20.r,
                          borderColor: AppColors.yellow,
                          text: 'Back',
                          textColor: AppColors.yellow,
                          containerColor: Colors.transparent,
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
                          borderRadius: 20.r,
                          innerPadding: EdgeInsets.symmetric(
                            vertical: 8.sp,
                            horizontal: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.sp),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// ===============================
  /// Assessment Row Widget
  /// ===============================
  Widget _buildAssessmentRow({
    required String title,
    required String groupValue,
    required Function(String?) onChanged,
    bool isParent = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isParent ? 15.sp : 14.sp,
            fontWeight:
            isParent ? FontWeight.bold : FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.sp),

        Row(
          children: [
            Expanded(child: _radioItem('Poor', groupValue, onChanged)),
            Expanded(child: _radioItem('Average', groupValue, onChanged)),
          ],
        ),
        SizedBox(height: 5.sp),

        Row(
          children: [
            Expanded(child: _radioItem('Good', groupValue, onChanged)),
            Expanded(
                child: _radioItem('Excellent', groupValue, onChanged)),
          ],
        ),
        SizedBox(height: 5.sp),

        _radioItem('Not Applicable', groupValue, onChanged),

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


