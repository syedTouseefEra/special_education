
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/screen/student/profile_detail/country_state_data_model.dart';

class CountryPickerModal extends StatelessWidget {
  final List<CountryDataModal> countries;
  final void Function(CountryDataModal) onCountrySelected;

  const CountryPickerModal({
    super.key,
    required this.countries,
    required this.onCountrySelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: countries.length,
      itemBuilder: (context, index) {
        final country = countries[index];
        return ListTile(
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
            child: Text(country.countryName ?? ""),
          ),
          onTap: () {
            onCountrySelected(country);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
