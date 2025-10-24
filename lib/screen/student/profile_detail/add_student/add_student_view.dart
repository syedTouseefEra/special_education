import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/components/custom_appbar.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/screen/student/profile_detail/country_state_data_model.dart';
import 'package:special_education/screen/student/student_dashboard_provider.dart';

import 'package:special_education/components/custom_api_call.dart';
import 'widgets/section_header.dart';
import 'widgets/form_text_field.dart';
import 'widgets/date_of_birth_picker.dart';
import 'widgets/upload_image_box.dart';
import 'widgets/country_picker_modal.dart';
import 'widgets/state_picker_modal.dart';
import 'widgets/city_picker_modal.dart';
import 'widgets/save_button.dart';

class AddStudentView extends StatefulWidget {
  const AddStudentView({super.key});

  @override
  State<AddStudentView> createState() => _AddStudentViewState();
}

class _AddStudentViewState extends State<AddStudentView> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController pidController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController aadharCardController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  File? _aadharCardImage;
  File? _studentImage;

  String? _uploadedAadharImageName;
  String? _uploadedStudentImageName;


  List<CountryDataModal> _countries = [];
  List<StateDataModel> _states = [];
  List<CityDataModel> _cities = [];

  int selectedCountryId = 0;
  int selectedStateId = 0;
  int selectedCityId = 0;
  int selectedNationality = 0;

  final locationService = LocationService();

  @override
  void initState() {
    super.initState();
    loadCountries();
  }

  Future<void> _pickImage(bool isAadhar) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final provider = Provider.of<StudentDashboardProvider>(context, listen: false);

      setState(() {
        if (isAadhar) {
          _aadharCardImage = File(picked.path);
        } else {
          _studentImage = File(picked.path);
        }
      });

      String? uploadedImageName = await provider.uploadImage(picked.path, context);

      if (uploadedImageName != null) {
        setState(() {
          if (isAadhar) {
            _uploadedAadharImageName = uploadedImageName; // <-- store uploaded aadhar image name
          } else {
            _uploadedStudentImageName = uploadedImageName; // <-- store uploaded student image name
          }
        });
      }
    }
  }


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

  var updateGender = [
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

  void _submitForm() {
    print("_submitForm Pressed");
    // Trimmed text fields
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final mobileNumber = mobileNumberController.text.trim();
    final diagnosis = diagnosisController.text.trim();
    final gender = genderController.text.trim();
    final pid = pidController.text.trim();
    final pincode = pincodeController.text.trim();
    final country = countryController.text.trim();
    final state = stateController.text.trim();
    final city = cityController.text.trim();
    final nationality = nationalityController.text.trim();

    // Validation
    if (firstName.isEmpty) {
      showSnackBar("First name is required", context);
      return;
    }

    if (mobileNumber.isEmpty) {
      showSnackBar("Mobile number is required", context);
      return;
    }

    if (mobileNumber.length <10) {
      showSnackBar("Mobile number is invalid", context);
      return;
    }

    if (diagnosis.isEmpty) {
      showSnackBar("Diagnosis is required", context);
      return;
    }

    if (gender.isEmpty) {
      showSnackBar("Gender is required", context);
      return;
    }

    if (pid.isEmpty) {
      showSnackBar("PID number is required", context);
      return;
    }

    if (pincode.length <6) {
      showSnackBar("Pincode is invalid", context);
      return;
    }

    if (country.isEmpty) {
      showSnackBar("Country is required", context);
      return;
    }

    if (state.isEmpty) {
      showSnackBar("State is required", context);
      return;
    }

    if (city.isEmpty) {
      showSnackBar("City is required", context);
      return;
    }

    if (nationality.isEmpty) {
      showSnackBar("Nationality is required", context);
      return;
    }

    if (_studentImage == null) {
      showSnackBar("Student image is required", context);
      return;
    }

    // Proceed with form submission if all validations pass

    final middleName = middleNameController.text.trim();
    final emailId = emailController.text.trim();
    final dob = selectedDate;
    final genderId = gender == 'Male'
        ? 1
        : gender == 'Female'
        ? 2
        : 3;
    final pidNumber = int.tryParse(pid) ?? 0;
    final pinCode = pincodeController.text.trim();
    final addressLine1 = addressLine1Controller.text.trim();
    final addressLine2 = addressLine2Controller.text.trim();
    final countryId = selectedCountryId;
    final stateId = selectedStateId;
    final cityId = selectedCityId;
    final nationalityId = selectedNationality;
    final aadharCardNumber = aadharCardController.text.trim();

    final aadharCardImageName = _aadharCardImage?.path.split('/').last;
    final studentImageName = _studentImage?.path.split('/').last;

    Provider.of<StudentDashboardProvider>(context, listen: false).addStudent(
      firstName: firstName,
      middleName: middleName.isEmpty ? null : middleName,
      lastName: lastName,
      mobileNumber: mobileNumber,
      emailId: emailId.isEmpty ? null : emailId,
      diagnosis: diagnosis,
      dob: dob,
      genderId: genderId,
      pidNumber: pidNumber,
      pinCode: pinCode.isEmpty ? null : pinCode,
      addressLine1: addressLine1.isEmpty ? null : addressLine1,
      addressLine2: addressLine2.isEmpty ? null : addressLine2,
      countryId: countryId,
      stateId: stateId,
      cityId: cityId,
      nationalityId: nationalityId,
      aadharCardNumber: aadharCardNumber,
      aadharCardImageName: aadharCardImageName,
      studentImageName: studentImageName,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    CustomText(
                      text: 'Add Student',
                      fontSize: 22.sp,
                      color: AppColors.themeColor,
                      fontFamily: 'Dm Serif',
                      fontWeight: FontWeight.w600,
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
                      label: "Diagnosis",
                      controller: diagnosisController,
                      isRequired: true,
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
                    FormTextField(
                      label: "PID Number",
                      controller: pidController,
                      isRequired: true,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                    ),

                    SizedBox(height: 25.sp),

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

                    SizedBox(height: 25.sp),
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
                    ),

                    UploadImageBox(
                      title: "Aadhar Card Image",
                      imageFile: _aadharCardImage,
                      onTap: () => _pickImage(true),
                      onClear: () => setState(() => _aadharCardImage = null),
                      requiredField: false,
                    ),
                    SizedBox(height: 15.sp),
                    UploadImageBox(
                      title: "Student Image",
                      imageFile: _studentImage,
                      onTap: () => _pickImage(false),
                      onClear: () => setState(() => _studentImage = null),
                      requiredField: true,
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
    diagnosisController.dispose();
    genderController.dispose();
    pidController.dispose();
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
