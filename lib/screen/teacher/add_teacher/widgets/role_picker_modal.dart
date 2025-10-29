
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/screen/student/profile_detail/country_state_data_model.dart';
import 'package:special_education/screen/teacher/teacher_data_model.dart';

class RolePickerModal extends StatelessWidget {
  final List<RoleDataModal> role;
  final void Function(RoleDataModal) onRoleSelected;

  const RolePickerModal({
    super.key,
    required this.role,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: role.length,
      itemBuilder: (context, index) {
        final item = role[index];
        return ListTile(
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
            child: Text(item.name.toString()),
          ),
          onTap: () {
            onRoleSelected(item);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
