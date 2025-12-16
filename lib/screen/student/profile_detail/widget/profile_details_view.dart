import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/constant/assets.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/label_value_text.dart';
import 'package:special_education/screen/student/profile_detail/student_profile_data_model.dart';
import 'package:special_education/screen/student/profile_detail/update_student_profile_detail/update_academic_skill_view.dart';
import 'package:special_education/screen/student/profile_detail/update_student_profile_detail/update_psycho_motor_skill_view.dart';
import 'package:special_education/utils/navigation_utils.dart';
import 'package:special_education/utils/text_case_utils.dart';

class ProfileDetailsView extends StatelessWidget {
  final StudentProfileDataModel student;
  const ProfileDetailsView({super.key,required this.student});

  @override
  Widget build(BuildContext context) {

    String getRatingDescription(int ratingId) {
      switch (ratingId) {
        case 1:
          return "Poor";
        case 2:
          return "Average";
        case 3:
          return "Good";
        case 4:
          return "Excellent";
        case 0:
          return "Not Applicable";
        default:
          return "Unknown Rating";
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.sp),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey, width: 1.sp),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: student.skillList!.map<Widget>((skill) {
            if (skill.name == "Academic Skill") {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(thickness: 1,),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.sp, 10.sp, 10.sp, 10.sp),
                    child: CustomText(
                      text: 'Pre- Assessment | ${skill.name!}',
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: AppColors.themeColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: Divider(thickness: 1),
                  ),
                  ...skill.skillRating!.map<Widget>((rating) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(15.sp, 5.sp, 10.sp, 5.sp),
                          child: CustomText(
                            text: rating.name!,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: AppColors.textGrey,
                          ),
                        ),
                        if (rating.quality != null && rating.quality!.isNotEmpty)
                          ...rating.quality!.map<Widget>((quality) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(20.sp, 0, 10.sp, 5.sp),
                              child: LabelValueText(
                                isRow: true,
                                label: "${quality.name!}:",
                                value: getRatingDescription(quality.ratingId ?? 0),
                                labelStyle: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grey,
                                ),
                                valueStyle: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.textGrey,
                                ),
                                valueCase: TextCase.title,
                              ),
                            );
                          })
                        else
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.sp, 0, 10.sp, 5.sp),
                            child: LabelValueText(
                              isRow: true,
                              label: "${rating.name!}:",
                              value: rating.ratingId.toString(),
                              labelStyle: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.grey,
                              ),
                              valueStyle: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textGrey,
                              ),
                              valueCase: TextCase.title,
                            ),
                          )
                      ],
                    );
                  }),
                  Padding(
                    padding: EdgeInsets.all(15.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: (){
                            NavigationHelper.push(context, UpdateAcademicSkillView(id: student.studentId.toString(),));
                          },
                          child: CustomContainer(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            borderRadius: 8.r,
                            text: 'Update',
                            containerColor: AppColors.green,
                            padding: 1,
                            innerPadding: EdgeInsets.symmetric(
                              vertical: 8.sp,
                              horizontal: 30.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(thickness: 1,),
                  Padding(
                    padding: EdgeInsets.all(6.sp),
                    child: Row(
                      children: [
                        CustomText(text: "Aadhar Card :", fontSize: 14.sp,color: AppColors.themeBlue,fontWeight: FontWeight.w500,),
                        CustomText(text: student.aadharCardNumber.toString()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.sp),
                    child: Divider(thickness: 1),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: Container(
                      height: 100.sp,
                      width: 200.sp,
                      decoration: BoxDecoration(
                        color: AppColors.themeColor,
                        image: student.aadharCardImage != null && student.aadharCardImage!.isNotEmpty
                            ? DecorationImage(
                          image: NetworkImage(
                            '${ApiServiceUrl.urlLauncher}uploads/${student.aadharCardImage}',
                          ),
                          fit: BoxFit.cover,
                        )
                            : const DecorationImage(
                          image: AssetImage(ImgAssets.user),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10), // optional: for slightly rounded corners
                      ),
                    ),
                  ),
                  SizedBox(height: 20.sp,)

                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10.sp, 15.sp, 10.sp, 10.sp),
                    child: CustomText(
                      text: 'Pre- Assessment | ${skill.name!}',
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: AppColors.themeColor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: Divider(thickness: 1),
                  ),
                  ...skill.skillRating!.map<Widget>((rating) {
                    String label = rating.name!;
                    if (rating.quality != null && rating.quality!.isNotEmpty) {
                      final qualityNames = rating.quality!.map((q) => q.name).join(", ");
                      label += " ($qualityNames)";
                    }

                    return Padding(
                      padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 5.sp),
                      child: LabelValueText(
                        isRow: true,
                        label: "$label:",
                        value: getRatingDescription(rating.ratingId ?? 0),
                        labelStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey,
                        ),
                        valueStyle: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textGrey,
                        ),
                        valueCase: TextCase.title,
                      ),
                    );
                  }),
                  Padding(
                    padding: EdgeInsets.all(15.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: (){
                            NavigationHelper.push(context, UpdatePsychoMotorAssessmentView(id: student.studentId.toString(),));
                          },
                          child: CustomContainer(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            borderRadius: 8.r,
                            text: 'Update',
                            containerColor: AppColors.green,
                            padding: 1,
                            innerPadding: EdgeInsets.symmetric(
                              vertical: 8.sp,
                              horizontal: 30.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          }).toList(),
        )
      ),
    );
  }
}
