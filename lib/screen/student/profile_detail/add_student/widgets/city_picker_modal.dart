
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/screen/student/profile_detail/country_state_data_model.dart';

class CityPickerModal extends StatelessWidget {
  final List<CityDataModel> cities;
  final void Function(CityDataModel) onCitySelected;

  const CityPickerModal({
    super.key,
    required this.cities,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cities.length,
      itemBuilder: (context, index) {
        final city = cities[index];
        return ListTile(
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
            child: Text(city.cityName ?? ""),
          ),
          onTap: () {
            onCitySelected(city);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
