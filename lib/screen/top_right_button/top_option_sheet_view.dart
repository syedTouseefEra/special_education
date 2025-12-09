import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/screen/login/login_view.dart';
import 'package:special_education/screen/top_right_button/change_password/change_password_view.dart';
import 'package:special_education/user_data/user_data.dart';
import 'package:special_education/utils/navigation_utils.dart';

void showTopSheet(BuildContext context, Widget child) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withValues(alpha: 0.3),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.topCenter,
        child: Material(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.r),bottomRight: Radius.circular(20.r)),
          color: Colors.white,
          child: SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.50, // control height
              ),
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.sp),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) => SlideTransition(
      position: Tween(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic)),
      child: child,
    ),
  );
}

class TopOptionSheet extends StatelessWidget {
  final String name;
  final String subtitle;
  final String profileImage;

  const TopOptionSheet({
    super.key,
    required this.name,
    required this.subtitle,
    required this.profileImage,
  });

  List<Map<String, dynamic>> _tempData(BuildContext context) => [
    {"icon": Icons.person_rounded, "title": 'My Profile', "onTap": () {}},
    {"icon": Icons.group_add_sharp, "title": 'Classroom Panel', "onTap": () {}},
    {"icon": Icons.lock_person_rounded, "title": 'Change Password', "onTap": () {
      NavigationHelper.push(context, ChangePasswordView());
    }},

  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 0,
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 36, backgroundImage: NetworkImage(profileImage)),
        SizedBox(height: 5.sp),
        CustomText(text: name,fontSize: 18.sp, fontWeight: FontWeight.bold),
        CustomText(text: subtitle,fontSize: 14.sp, color: Colors.grey.shade600),

        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _tempData(context).length,
          itemBuilder: (context, index) {
            final data = _tempData(context)[index];
            return _buildListItem(
              icon: data["icon"],
              title: data["title"],
              onTap: data["onTap"],
            );
          },
        ),
        Divider(thickness: 1.sp),
        SizedBox(height: 5.sp,),
        InkWell(
          splashColor: AppColors.transparent,
          highlightColor: AppColors.transparent,
          onTap: (){
            UserData().removeUserData();
            NavigationHelper.pushAndClearStack(context, LoginPage());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 18.sp,),
              Icon(Icons.logout,color: AppColors.red, size: 20.sp,),
              SizedBox(width: 15.sp,),
              CustomText(text: "Logout",fontSize: 14.sp, color: AppColors.red),
            ]
          ),
        ),

      ],
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      child: Container(
        color: Colors.white,

        child: ListTile(
          shape: const Border(bottom: BorderSide(color: Colors.grey)),
          leading: Icon(icon, color: Colors.black54),
          title: Text(title),
          onTap: onTap,
          dense: true,
        ),
      ),
    );
  }
}

