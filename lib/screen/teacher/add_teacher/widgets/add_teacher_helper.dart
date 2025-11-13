import 'package:flutter/material.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/screen/student/profile_detail/country_state_data_model.dart';
import 'package:special_education/screen/teacher/add_teacher/widgets/role_picker_modal.dart';
import 'package:special_education/screen/teacher/add_teacher/widgets/country_picker_modal.dart';
import 'package:special_education/screen/teacher/add_teacher/widgets/state_picker_modal.dart';
import 'package:special_education/screen/teacher/add_teacher/widgets/city_picker_modal.dart';
import 'package:special_education/components/custom_api_call.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/screen/teacher/teacher_data_model.dart';

class AddTeacherHelper {
  final LocationService locationService = LocationService();

  Future<List<CountryDataModal>> loadCountries() async {
    return await locationService.fetchLocationData<CountryDataModal>(
      url: "${ApiServiceUrl.countryBaseUrl}${ApiServiceUrl.getCountry}",
      fromJson: CountryDataModal.fromJson,
    );
  }

  Future<List<StateDataModel>> loadStates(String countryId) async {
    return await locationService.fetchLocationData<StateDataModel>(
      params: {"countryId": countryId},
      url: "${ApiServiceUrl.countryBaseUrl}${ApiServiceUrl.getState}",
      fromJson: StateDataModel.fromJson,
    );
  }
  Future<List<CityDataModel>> loadCities(BuildContext context, String stateId) async {
    try {
      final cities = await locationService.fetchLocationData<CityDataModel>(
        params: {"stateId": stateId},
        url: "${ApiServiceUrl.countryBaseUrl}${ApiServiceUrl.getCity}",
        fromJson: CityDataModel.fromJson,
      );

      if (cities.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('City not found in this state')),
        );
      }

      return cities;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load cities: $e')),
      );
      return [];
    }
  }

  Future<List<RoleDataModal>> loadRoles() async {
    return await locationService.fetchLocationData<RoleDataModal>(
      params: {"": ""},
      url: "${ApiServiceUrl.countryBaseUrl}${ApiServiceUrl.masterRole}",
      fromJson: RoleDataModal.fromJson,
    );
  }

  void openGenderPicker({
    required BuildContext context,
    required TextEditingController controller,
  }) {
    final genders = [
      {'id': 1, 'status': "Male"},
      {'id': 2, 'status': "Female"},
      {'id': 3, 'status': "Others"},
    ];

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          children: genders.map((gender) {
            return ListTile(
              title: CustomText(text: gender['status'].toString()),
              onTap: () {
                controller.text = gender['status'].toString();
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void openCountryPicker({
    required BuildContext context,
    required List<CountryDataModal> countries,
    required Function(CountryDataModal) onCountrySelected,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (_) => CountryPickerModal(
        countries: countries,
        onCountrySelected: (country) {
          onCountrySelected(country);
        },
      ),
    );
  }

  void openStatePicker({
    required BuildContext context,
    required List<StateDataModel> states,
    required Function(StateDataModel) onStateSelected,
  }) {
    if (states.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Select a country first")));
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) => StatePickerModal(
        states: states,
        onStateSelected: (state) {
          onStateSelected(state);
        },
      ),
    );
  }

  void openCityPicker({
    required BuildContext context,
    required List<CityDataModel> cities,
    required Function(CityDataModel) onCitySelected,
  }) {
    if (cities.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Select a state first")));
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) => CityPickerModal(
        cities: cities,
        onCitySelected: (city) {
          onCitySelected(city);
          Navigator.pop(context);
        },
      ),
    );
  }

  void openRolePicker({
    required BuildContext context,
    required List<RoleDataModal> roles,
    required Function(RoleDataModal) onRoleSelected,
  }) {
    if (roles.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No roles available")));
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) => RolePickerModal(
        role: roles,
        onRoleSelected: (item) {
          onRoleSelected(item);
        },
      ),
    );
  }
}
