import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/components/custom_appbar.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
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
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.sp),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 10.sp),
                      CustomHeaderView(courseName: "", moduleName: "Profile Details"),
                    ],
                  ),
                ),
                if (teacher != null)
                  CustomContainer(
                    fontSize: 12.sp,
                    text: 'Remove Teacher',
                    containerColor: AppColors.red,
                    borderRadius: 20.r,
                    innerPadding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 8.h,
                    ),
                    onTap: () async {
                      doubleButton(
                        context,
                        "",
                        "Are you sure? You can't undo this action afterwards.",
                            () async {
                          Navigator.pop(context);
                          final success = await provider.deleteTeacher(
                            context,
                            widget.id.toString(),
                          );

                          if (success && context.mounted) {
                            NavigationHelper.pop(context);
                          }
                        },
                      );
                    },
                  )
              ],
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(thickness: 0.7.sp),
                  SizedBox(height: 10.h),
                  const ProfileViewWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
