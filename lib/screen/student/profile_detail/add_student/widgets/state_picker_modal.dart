
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/screen/student/profile_detail/country_state_data_model.dart';

class StatePickerModal extends StatelessWidget {
  final List<StateDataModel> states;
  final void Function(StateDataModel) onStateSelected;

  const StatePickerModal({
    super.key,
    required this.states,
    required this.onStateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: states.length,
      itemBuilder: (context, index) {
        final state = states[index];
        return ListTile(
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
            child: Text(state.stateName ?? ""),
          ),
          onTap: () {
            onStateSelected(state);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
