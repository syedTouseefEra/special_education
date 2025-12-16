import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/custom_widget/custom_image_picker_preview.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/screen/student/profile_detail/country_state_data_model.dart';
import 'package:special_education/screen/student/profile_detail/student_profile_data_model.dart';
import 'package:special_education/screen/student/profile_detail/update_student_profile_detail/update_student_profile_data_model.dart';
import 'package:special_education/screen/student/profile_detail/update_student_profile_detail/update_student_profile_provider.dart';

import 'package:special_education/components/custom_api_call.dart';
import 'package:special_education/utils/navigation_utils.dart';

import '../add_student/widgets/city_picker_modal.dart';
import '../add_student/widgets/country_picker_modal.dart';
import '../add_student/widgets/date_of_birth_picker.dart';
import '../add_student/widgets/form_text_field.dart';
import '../add_student/widgets/section_header.dart';
import '../add_student/widgets/state_picker_modal.dart';

class UpdateStudentProfileView extends StatefulWidget {
  final StudentProfileDataModel student;
  const UpdateStudentProfileView({super.key, required this.student});

  @override
  State<UpdateStudentProfileView> createState() =>
      _UpdateStudentProfileViewState();
}

class _UpdateStudentProfileViewState extends State<UpdateStudentProfileView> {
  /// Controllers
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final emailController = TextEditingController();
  final diagnosisController = TextEditingController();

  final genderController = TextEditingController();
  final pidController = TextEditingController();
  final pincodeController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final nationalityController = TextEditingController();
  final aadharCardController = TextEditingController();

  bool _isDataSet = false;

  DateTime selectedDate = DateTime.now();

  late final ValueNotifier<File?> studentImageNotifier;
  late final ValueNotifier<File?> aadhaarImageFrontNotifier;
  late final ValueNotifier<String?> studentUploadedFileNameNotifier;
  late final ValueNotifier<String?> aadhaarFrontUploadedFileNameNotifier;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UpdateStudentProfileProvider>(
        context,
        listen: false,
      ).getStudentProfileDetail(
        context,
        widget.student.studentId.toString(),
      );
    });
    loadCountries();
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

  void _setStudentData(UpdateStudentProfileDataModel s) {
    if (_isDataSet) return;
    _isDataSet = true;

    firstNameController.text = s.firstName ?? '';
    middleNameController.text = s.middleName ?? '';
    lastNameController.text = s.lastName ?? '';
    mobileNumberController.text = s.mobileNumber ?? '';
    emailController.text = s.emailId ?? '';
    diagnosisController.text = s.diagnosis ?? '';

    // 🔽 EXTRA FIELDS
    genderController.text =
    s.genderId == 1 ? 'Male' : s.genderId == 2 ? 'Female' : 'Others';

    pidController.text = s.pidNumber?.toString() ?? '';
    pincodeController.text = s.pinCode ?? '';
    addressLine1Controller.text = s.addressLine1 ?? '';
    addressLine2Controller.text = s.addressLine2 ?? '';
    countryController.text = s.countryName ?? '';
    stateController.text = s.stateName ?? '';
    cityController.text = s.cityName ?? '';
    selectedCountryId = s.countryId ?? 0;
    selectedStateId = s.stateId ?? 0;
    selectedCityId = s.cityId ?? 0;
    selectedNationality = s.nationalityId ?? 0;
    nationalityController.text = s.nationalityName ?? '';
    aadharCardController.text = s.aadharCardNumber ?? '';
    studentImageNotifier = ValueNotifier<File?>(null);
    aadhaarImageFrontNotifier = ValueNotifier<File?>(null);

    studentUploadedFileNameNotifier =
        ValueNotifier<String?>(s.studentImage);

    aadhaarFrontUploadedFileNameNotifier =
        ValueNotifier<String?>(s.aadharCardImage);
  }


  void _submitForm() {
      print("adadadadadDAD");
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

    if (mobileNumber.length < 10) {
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

    if (pincode.length < 6) {
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

    if (studentImageNotifier.value == null &&
        studentUploadedFileNameNotifier.value == null) {
      showSnackBar("Student image is required", context);
      return;
    }


    final middleName = middleNameController.text.trim();
    final emailId = emailController.text.trim();
    final dob = selectedDate;
    final genderId = gender == 'Male'
        ? 1
        : gender == 'Female'
        ? 2
        : 3;
    final pidNumber = pid;
    final pinCode = pincodeController.text.trim();
    final addressLine1 = addressLine1Controller.text.trim();
    final addressLine2 = addressLine2Controller.text.trim();
    final countryId = selectedCountryId;
    final stateId = selectedStateId;
    final cityId = selectedCityId;
    final nationalityId = selectedNationality;
    final aadharCardNumber = aadharCardController.text.trim();

    final studentImageName =
        studentUploadedFileNameNotifier.value;

    final aadharCardImageName =
        aadhaarFrontUploadedFileNameNotifier.value;


    Provider.of<UpdateStudentProfileProvider>(context, listen: false).updateStudentProfile(context,
      id: widget.student.studentId.toString(),
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
    return Consumer<UpdateStudentProfileProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.studentProfileData != null &&
            provider.studentProfileData!.isNotEmpty) {
          _setStudentData(provider.studentProfileData!.first);
        }

        return _buildUI();
      },
    );
  }

  Widget _buildUI() {
    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.sp),
            child: Column(
              children: [
                SizedBox(height: 5.sp),
                CustomHeaderView(
                  courseName: "",
                  moduleName: "Update Student",
                ),
                Divider(thickness: 0.7.sp),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 18.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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


                ImagePickerWithPreview(
                  title: 'Aadhar Card Image',
                  requiredField: true,
                  imageFileNotifier: aadhaarImageFrontNotifier,
                  uploadedFolderName: 'Uploads',
                  uploadButtonText: "Upload Image",
                  containerHeight: 40,
                  thumbnailHeight: 120,
                  thumbnailWidth: 200,
                  fullscreenHeight: 500,
                  bottomSheetTitle: 'Update Aadhar Image',
                  uploadedFileNameNotifier: aadhaarFrontUploadedFileNameNotifier,
                ),
                SizedBox(height: 15.sp),
                ImagePickerWithPreview(
                  title: "Student Image",
                  requiredField: true,
                  imageFileNotifier: studentImageNotifier,
                  uploadButtonText: "Upload Image",
                  uploadedFolderName: 'Uploads',
                  containerHeight: 40,
                  thumbnailHeight: 120,
                  thumbnailWidth: 200,
                  fullscreenHeight: 500,
                  bottomSheetTitle: 'Update Student Image',
                  uploadedFileNameNotifier: studentUploadedFileNameNotifier,
                ),

                SizedBox(height: 50.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    splashColor: AppColors.transparent,
                    highlightColor: AppColors.transparent,
                    onTap: (){
                      NavigationHelper.pop(context);
                    },
                    child: CustomContainer(
                      borderRadius: 20.r,
                      borderColor: AppColors.yellow,
                      text: 'Back',
                      textColor: AppColors.yellow,
                      containerColor: AppColors.transparent,
                      padding: 1.sp,
                      innerPadding: EdgeInsets.symmetric(
                        vertical: 8.sp,
                        horizontal: 35.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.sp),
                  InkWell(
                    splashColor: AppColors.transparent,
                    highlightColor: AppColors.transparent,
                    onTap: _submitForm,
                    child: CustomContainer(
                      text: 'Save And Continue',
                      fontWeight: FontWeight.w400,
                      padding: 5.sp,
                      innerPadding: EdgeInsets.symmetric(horizontal: 18.sp, vertical: 8.sp),
                      borderRadius: 20.r,
                    ),
                  ),
                ],
              ),
                // SaveButton(onPressed: _submitForm),
                SizedBox(height: 40.sp),
              ],
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


