

import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';

class CustomHeaderSection extends StatelessWidget implements PreferredSizeWidget {
  const CustomHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5.sp),
        const CustomHeaderView(
          courseName: "Pre Assessment",
          moduleName: "Psycho-Motor Skill",
        ),
        Divider(thickness: 0.7.sp),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.sp);
}
