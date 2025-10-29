import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/components/custom_appbar.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/screen/student/profile_detail/country_state_data_model.dart';

import 'package:special_education/components/custom_api_call.dart';
import 'package:special_education/screen/teacher/add_teacher/widgets/role_picker_modal.dart';
import 'package:special_education/screen/teacher/teacher_dashboard_provider.dart';
import 'package:special_education/screen/teacher/teacher_data_model.dart';
import 'package:special_education/utils/image_upload_provider.dart';
import 'package:special_education/utils/navigation_utils.dart';
import 'widgets/section_header.dart';
import 'widgets/form_text_field.dart';
import 'widgets/date_of_birth_picker.dart';
import 'widgets/upload_image_box.dart';
import 'widgets/country_picker_modal.dart';
import 'widgets/state_picker_modal.dart';
import 'widgets/city_picker_modal.dart';
import 'widgets/save_button.dart';

class AddTeacherView extends StatefulWidget {
  const AddTeacherView({super.key});

  @override
  State<AddTeacherView> createState() => _AddTeacherViewState();
}

class _AddTeacherViewState extends State<AddTeacherView> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final TextEditingController roleIdController = TextEditingController();
  final TextEditingController joiningDateController = TextEditingController();

  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController aadharCardController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  DateTime joiningDate = DateTime.now();

  List<CountryDataModal> _countries = [];
  List<StateDataModel> _states = [];
  List<CityDataModel> _cities = [];
  List<RoleDataModal> _role = [];

  int selectedCountryId = 0;
  int selectedStateId = 0;
  int selectedCityId = 0;
  int selectedNationality = 0;
  int selectedRoleId = 0;

  final locationService = LocationService();

  @override
  void initState() {
    super.initState();
    loadCountries();
    loadRole();
    final imageProvider = Provider.of<ImageUploadProvider>(context, listen: false);
    imageProvider.clearImage('teacher');
    imageProvider.clearImage('aadhar');
    imageProvider.clearImage('signature');
  }

  // --- Loaders ---
  Future<void> loadCountries() async {
    final countries = await locationService.fetchLocationData<CountryDataModal>(
      url: "${ApiServiceUrl.countryBaseUrl}${ApiServiceUrl.getCountry}",
      fromJson: CountryDataModal.fromJson,
    );
    setState(() => _countries = countries);
  }

  Future<void> loadStates(String countryId) async {
    final states = await locationService.fetchLocationData<StateDataModel>(
      params: {"countryId": countryId},
      url: "${ApiServiceUrl.countryBaseUrl}${ApiServiceUrl.getState}",
      fromJson: StateDataModel.fromJson,
    );
    setState(() => _states = states);
  }

  Future<void> loadCities(String stateId) async {
    final cities = await locationService.fetchLocationData<CityDataModel>(
      params: {"stateId": stateId},
      url: "${ApiServiceUrl.countryBaseUrl}${ApiServiceUrl.getCity}",
      fromJson: CityDataModel.fromJson,
    );
    setState(() => _cities = cities);
  }

  Future<void> loadRole() async {
    final role = await locationService.fetchLocationData<RoleDataModal>(
      params: {"": ""},
      url: "${ApiServiceUrl.countryBaseUrl}${ApiServiceUrl.masterRole}",
      fromJson: RoleDataModal.fromJson,
    );
    setState(() => _role = role);
  }

  final List<Map<String, dynamic>> updateGender = [
    {'id': 1, 'status': "Male"},
    {'id': 2, 'status': "Female"},
    {'id': 3, 'status': "Others"},
  ];

  void _openGenderPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          children: updateGender.map((gender) {
            return ListTile(
              title: CustomText(text: gender['status']?.toString() ?? ''),
              onTap: () {
                genderController.text = gender['status'].toString();
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _openCountryPicker({required bool isNationality}) {
    showModalBottomSheet(
      context: context,
      builder: (_) => CountryPickerModal(
        countries: _countries,
        onCountrySelected: (country) {
          if (isNationality) {
            nationalityController.text = country.countryName ?? '';
            selectedNationality = country.countryId ?? 0;
          } else {
            countryController.text = country.countryName ?? '';
            selectedCountryId = country.countryId ?? 0;
            stateController.clear();
            cityController.clear();
            loadStates(country.countryId.toString());
          }
        },
      ),
    );
  }

  void _openStatePicker() {
    if (_states.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Select a country first")));
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) => StatePickerModal(
        states: _states,
        onStateSelected: (state) {
          stateController.text = state.stateName ?? '';
          selectedStateId = state.stateId ?? 0;
          cityController.clear();
          loadCities(state.stateId.toString());
        },
      ),
    );
  }

  void _openCityPicker() {
    if (_cities.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Select a state first")));
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) => CityPickerModal(
        cities: _cities,
        onCitySelected: (city) {
          cityController.text = city.cityName ?? '';
          selectedCityId = city.cityId ?? 0;
        },
      ),
    );
  }

  void _openRolePicker() {
    if (_role.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Select Your Role")));
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) => RolePickerModal(
        role: _role,
        onRoleSelected: (item) {
          roleIdController.text = item.name.toString();
          selectedRoleId = item.id ?? 0;
        },
      ),
    );
  }

  void _submitForm() {
    print("_submitForm Pressed");

    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final mobileNumber = mobileNumberController.text.trim();
    final employeeId = employeeIdController.text.trim();
    final gender = genderController.text.trim();
    final pincode = pincodeController.text.trim();
    final country = countryController.text.trim();
    final state = stateController.text.trim();
    final city = cityController.text.trim();
    final nationality = nationalityController.text.trim();

    final aadharCard = aadharCardController.text.trim();

    final imageProvider = Provider.of<ImageUploadProvider>(
      context,
      listen: false,
    );

    if (firstName.isEmpty) {
      return showSnackBar("First name is required", context);
    }
    if (lastName.isEmpty) {
      return showSnackBar("Last name is required", context);
    }
    if (mobileNumber.isEmpty) {
      return showSnackBar("Mobile number is required", context);
    }
    if (mobileNumber.length < 10) {
      return showSnackBar("Mobile number is invalid", context);
    }
    if (gender.isEmpty) return showSnackBar("Gender is required", context);
    if (pincode.isNotEmpty) {
      if (pincode.length != 6) {
        return showSnackBar("Pincode is invalid", context);
      }
    }

    if (country.isEmpty) return showSnackBar("Country is required", context);
    if (state.isEmpty) return showSnackBar("State is required", context);
    if (city.isEmpty) return showSnackBar("City is required", context);
    if (nationality.isEmpty) {
      return showSnackBar("Nationality is required", context);
    }
    if (aadharCard.isEmpty) {
      return showSnackBar("Aadhar card number is required", context);
    }
    if (aadharCard.length < 12) {
      return showSnackBar("Aadhar card number is invalid", context);
    }

    final provider = Provider.of<TeacherDashboardProvider>(
      context,
      listen: false,
    );

    provider.addTeacher(
      aadharCardImage: imageProvider.aadharImage?.path.split('/').last,
      aadharCardNumber: aadharCardController.text.trim(),
      addressLine1: addressLine1Controller.text.trim(),
      addressLine2: addressLine2Controller.text.trim(),
      cityId: selectedCityId,
      countryId: selectedCountryId,
      dateOfBirth: selectedDate,
      emailId: emailController.text.trim().isEmpty
          ? null
          : emailController.text.trim(),
      employeeId: employeeId,
      firstName: firstName,
      genderId: gender == 'Male'
          ? 1
          : gender == 'Female'
          ? 2
          : 3,
      instituteId: 22,
      joiningDate: joiningDate,
        lastName: lastNameController.text.trim().isEmpty ? "" : lastNameController.text.trim(),
        middleName: middleNameController.text.trim().isEmpty ? "" : middleNameController.text.trim(),
      mobileNumber: mobileNumber,
      nationalityId: selectedNationality,
      pinCode: pincodeController.text.trim(),
      roleId: 7,
      signature: imageProvider.signatureImage?.path.split('/').last,
      stateId: selectedStateId,
      image: imageProvider.teacherImage?.path.split('/').last,
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageUploadProvider>(context);

    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: const CustomAppBar(enableTheming: false),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.sp, vertical: 15.sp),
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            NavigationHelper.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 20.sp,
                            color: AppColors.themeColor,
                          ),
                        ),
                        CustomText(
                          text: 'Add New Teacher',
                          fontSize: 22.sp,
                          color: AppColors.themeColor,
                          fontFamily: 'Dm Serif',
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),

                    SizedBox(height: 10.sp),

                    const SectionHeader(title: 'General Information'),

                    FormTextField(
                      label: "First Name",
                      controller: firstNameController,
                      isRequired: true,
                      onlyLetters: true,
                    ),
                    FormTextField(
                      label: "Middle Name",
                      controller: middleNameController,
                      onlyLetters: true,
                    ),
                    FormTextField(
                      label: "Last Name",
                      controller: lastNameController,
                      onlyLetters: true,
                      isRequired: true,
                    ),
                    FormTextField(
                      label: "Mobile Number",
                      controller: mobileNumberController,
                      isRequired: true,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                    ),
                    FormTextField(
                      label: "Email ID",
                      controller: emailController,
                      isEmail: true,
                    ),
                    FormTextField(
                      label: "Employee ID",
                      controller: employeeIdController,
                      isRequired: true,
                      onlyLettersAndNumbers: true,
                    ),
                    DateOfBirthPicker(
                      selectedDate: selectedDate,
                      onChanged: (date) => setState(() => selectedDate = date),
                    ),
                    FormTextField(
                      label: "Gender",
                      controller: genderController,
                      isEditable: false,
                      isRequired: true,
                      suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      onTap: _openGenderPicker,
                    ),
                    SizedBox(height: 10.sp),

                    const SectionHeader(title: 'Address Details'),
                    FormTextField(
                      label: "Pincode",
                      controller: pincodeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                    ),
                    FormTextField(
                      label: "Address Line 1",
                      controller: addressLine1Controller,
                    ),
                    FormTextField(
                      label: "Address Line 2",
                      controller: addressLine2Controller,
                    ),
                    FormTextField(
                      label: "Country",
                      controller: countryController,
                      isEditable: false,
                      isRequired: true,
                      suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      onTap: () => _openCountryPicker(isNationality: false),
                    ),
                    FormTextField(
                      label: "State",
                      controller: stateController,
                      isEditable: false,
                      isRequired: true,
                      suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      onTap: _openStatePicker,
                    ),
                    FormTextField(
                      label: "City/Town",
                      controller: cityController,
                      isEditable: false,
                      isRequired: true,
                      suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      onTap: _openCityPicker,
                    ),

                    SizedBox(height: 10.sp),
                    const SectionHeader(title: 'Employment Details'),
                    FormTextField(
                      label: "Role",
                      controller: roleIdController,
                      isEditable: false,
                      isRequired: true,
                      suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      onTap: _openRolePicker,
                    ),
                    DateOfBirthPicker(
                      isRequired: false,
                      labelText: 'Joining Date',
                      selectedDate: joiningDate,
                      onChanged: (date) => setState(() => joiningDate = date),
                    ),

                    SizedBox(height: 10.sp),
                    const SectionHeader(title: 'Additional Details'),
                    FormTextField(
                      label: "Nationality",
                      controller: nationalityController,
                      isEditable: false,
                      isRequired: true,
                      suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      onTap: () => _openCountryPicker(isNationality: true),
                    ),
                    FormTextField(
                      label: "Aadhar Card Number",
                      controller: aadharCardController,
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                      isRequired: true,
                    ),

                    UploadImageBox(
                      title: "Aadhar Card Image",
                      imageFile: imageProvider.aadharImage,
                      onTap: () =>
                          imageProvider.pickAndUploadImage(context, 'aadhar'),
                      onClear: () => imageProvider.clearImage('aadhar'),
                    ),

                    SizedBox(height: 15.sp),
                    UploadImageBox(
                      title: "Teacher Image",
                      imageFile: imageProvider.teacherImage,
                      onTap: () =>
                          imageProvider.pickAndUploadImage(context, 'teacher'),
                      onClear: () => imageProvider.clearImage('teacher'),
                    ),
                    SizedBox(height: 15.sp),
                    UploadImageBox(
                      title: "Teacher Signature",
                      imageFile: imageProvider.signatureImage,
                      onTap: () => imageProvider.pickAndUploadImage(
                        context,
                        'signature',
                      ),
                      onClear: () => imageProvider.clearImage('signature'),
                    ),
                    SizedBox(height: 40.sp),
                    SaveButton(onPressed: _submitForm),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    mobileNumberController.dispose();
    emailController.dispose();
    genderController.dispose();
    pincodeController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    nationalityController.dispose();
    aadharCardController.dispose();
    super.dispose();
  }
}
