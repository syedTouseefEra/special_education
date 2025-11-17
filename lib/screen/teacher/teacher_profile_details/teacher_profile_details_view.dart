import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/components/custom_appbar.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/screen/teacher/teacher_dashboard_provider.dart';
import 'package:special_education/screen/teacher/teacher_profile_details/widgets/profile_view.dart';
import 'package:special_education/utils/navigation_utils.dart';

class TeacherProfileDetailsView extends StatefulWidget {
  final int id;

  const TeacherProfileDetailsView({super.key, required this.id});

  @override
  State<TeacherProfileDetailsView> createState() =>
      _TeacherProfileDetailsViewState();
}

class _TeacherProfileDetailsViewState extends State<TeacherProfileDetailsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TeacherDashboardProvider>(
        context,
        listen: false,
      ).fetchTeacherProfileDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TeacherDashboardProvider>(context);
    final teacher = provider.teacherData;

    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: const CustomAppBar(enableTheming: false),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () => NavigationHelper.pop(context),
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 20.sp,
                                color: AppColors.themeColor,
                              ),
                            ),
                            CustomText(
                              text: 'Profile Details',
                              fontSize: 18.sp,
                              color: AppColors.themeColor,
                              fontFamily: 'Dm Serif',
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        if (teacher != null)
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              doubleButton(
                                context,
                                "",
                                "Are you sure? You can't undo this action afterwards.",
                                () async {
                                  Navigator.pop(context); // close dialog
                                  final success = await provider.deleteTeacher(
                                    context,
                                    widget.id.toString(),
                                  );

                                  if (success && context.mounted) {
                                    NavigationHelper.pop(context); // go back
                                  }
                                },
                              );
                            },
                            child: CustomContainer(
                              fontSize: 12.sp,
                              text: 'Remove Teacher',
                              containerColor: AppColors.red,
                              borderRadius: 20.r,
                              padding: 12.sp,
                              innerPadding: EdgeInsets.symmetric(
                                horizontal: 15.w,
                                vertical: 8.h,
                              ),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 15.h),

                    const ProfileViewWidget(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
