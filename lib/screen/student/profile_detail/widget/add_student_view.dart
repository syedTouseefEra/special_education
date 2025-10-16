import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/custom_api_call.dart';
import 'package:special_education/components/custom_appbar.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/custom_upload_image_view.dart';
import 'package:special_education/custom_widget/field_label_row.dart';
import 'package:special_education/custom_widget/text_field.dart';
import 'package:special_education/screen/student/profile_detail/country_state_data_model.dart';
import 'package:special_education/screen/student/student_dashboard_provider.dart';
import 'package:special_education/utils/date_picker_utils.dart';

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
  File? _studentImage;
  File? _aadharCardImage;

  List<CountryDataModal> _countries = [];
  List<StateDataModel> _state = [];
  List<CityDataModel> _city = [];

  String _selectedCountryId = "";

  Future<void> _pickStudentImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _studentImage = File(pickedFile.path));
    }
  }

  Future<void> _pickAadharImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _aadharCardImage = File(pickedFile.path));
    }
  }

  final locationService = LocationService();

  Future<void> loadCountries() async {
    try {
      final countries = await locationService
          .fetchLocationData<CountryDataModal>(
            url: "${ApiServiceUrl.countryBaseUrl}${ApiServiceUrl.getCountry}",
            fromJson: (json) => CountryDataModal.fromJson(json),
          );

      setState(() {
        _countries = countries;
      });
    } catch (e) {}
  }

  Future<void> loadState(String countryId) async {
    try {
      final states = await locationService.fetchLocationData<StateDataModel>(
        params: {"countryId": countryId},
        url: "${ApiServiceUrl.countryBaseUrl}${ApiServiceUrl.getState}",
        fromJson: (json) => StateDataModel.fromJson(json),
      );

      setState(() {
        _state = states;
      });
    } catch (e) {}
  }

  Future<void> loadCity(String stateId) async {
    try {
      final city = await locationService.fetchLocationData<CityDataModel>(
        params: {"stateId": stateId},
        url: "${ApiServiceUrl.countryBaseUrl}${ApiServiceUrl.getCity}",
        fromJson: (json) => CityDataModel.fromJson(json),
      );

      setState(() {
        _city = city;
      });
    } catch (e) {}
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isRequired = false,
    bool isEditable = true,
    Widget? suffixIcon,
    ValueChanged<String>? onChanged,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(
          text: label,
          isRequired: isRequired,
          fontSize: 14.sp,
          color: AppColors.black,
        ),
        SizedBox(height: 5.sp),
        CustomTextField(
          controller: controller,
          borderRadius: 8.sp,
          borderColor: AppColors.grey,
          isEditable: isEditable,
          label: 'Enter $label',
          suffixIcon: suffixIcon,
          onChanged: onChanged, // Pass it here, can be null
          onTap: onTap, // Pass it here, can be null
        ),
        SizedBox(height: 7.sp),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    loadCountries();
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: _countries.length,
          itemBuilder: (context, index) {
            final country = _countries[index];
            return ListTile(
              title: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.sp,
                  vertical: 5.sp,
                ),
                child: Text(country.countryName.toString()),
              ),
              onTap: () {
                setState(() {
                  countryController.text = country.countryName
                      .toString();
                  loadState(country.countryId.toString());
                  stateController.clear();
                  cityController.clear();
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showStatePicker() {
    if (_state.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a country first')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: _state.length,
          itemBuilder: (context, index) {
            final state = _state[index];
            return ListTile(
              title: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.sp,
                  vertical: 5.sp,
                ),
                child: Text(state.stateName.toString()),
              ),
              onTap: () {
                setState(() {
                  stateController.text = state.stateName
                      .toString();
                  loadCity(state.stateId.toString());
                  cityController.clear();
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showCityPicker() {
    if (_city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a state first')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: _city.length,
          itemBuilder: (context, index) {
            final city = _city[index];
            return ListTile(
              title: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.sp,
                  vertical: 5.sp,
                ),
                child: Text(city.cityName.toString()),
              ),
              onTap: () {
                setState(() {
                  cityController.text = city.cityName
                      .toString(); // Update UI
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
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

                  CustomText(
                    text: 'General Information',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 5.sp),
                  const Divider(thickness: 1),
                  SizedBox(height: 10.sp),

                  _buildTextField(
                    label: "First Name",
                    controller: firstNameController,
                    isRequired: true,
                  ),
                  _buildTextField(
                    label: "Middle Name",
                    controller: middleNameController,
                  ),
                  _buildTextField(
                    label: "Last Name",
                    controller: lastNameController,
                  ),
                  _buildTextField(
                    label: "Mobile Number",
                    controller: mobileNumberController,
                    isRequired: true,
                  ),
                  _buildTextField(
                    label: "Email ID",
                    controller: emailController,
                  ),
                  _buildTextField(
                    label: "Diagnosis",
                    controller: diagnosisController,
                    isRequired: true,
                  ),

                  FieldLabel(
                    text: "Date of Birth",
                    isRequired: true,
                    fontSize: 14.sp,
                    color: AppColors.black,
                  ),
                  SizedBox(height: 5.sp),
                  DatePickerHelper.datePicker(
                    borderColor: AppColors.grey,
                    iconColor: AppColors.grey,
                    context,
                    date: selectedDate,
                    onChanged: (newDate) {
                      setState(() => selectedDate = newDate);
                    },
                  ),
                  SizedBox(height: 7.sp),

                  _buildTextField(
                    label: "Gender",
                    controller: genderController,
                    isRequired: true,
                    isEditable: false,
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                  ),
                  _buildTextField(
                    label: "PID Number",
                    controller: pidController,
                    isRequired: true,
                  ),

                  SizedBox(height: 25.sp),
                  CustomText(
                    text: 'Address Details',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 5.sp),
                  const Divider(thickness: 1),
                  SizedBox(height: 7.sp),

                  _buildTextField(
                    label: "Pincode",
                    controller: pincodeController,
                  ),
                  _buildTextField(
                    label: "Address Line 1",
                    controller: addressLine1Controller,
                  ),
                  _buildTextField(
                    label: "Address Line 2",
                    controller: addressLine2Controller,
                  ),
                  _buildTextField(
                    isEditable: false,
                    label: "Country",
                    controller: countryController,
                    isRequired: true,
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                    onTap: _showCountryPicker,
                  ),
                  _buildTextField(
                    isEditable: false,
                    label: "State",
                    controller: stateController,
                    isRequired: true,
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                    onTap: _showStatePicker,
                  ),
                  _buildTextField(
                    isEditable: false,
                    label: "City/Town",
                    controller: cityController,
                    isRequired: true,
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                    onTap: _showCityPicker
                  ),

                  SizedBox(height: 25.sp),
                  CustomText(
                    text: 'Additional Details',
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 5.sp),
                  const Divider(thickness: 1),

                  _buildTextField(
                    label: "Nationality",
                    controller: nationalityController,
                    isRequired: true,
                    isEditable: false,
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                  ),
                  _buildTextField(
                    label: "Aadhar Card Number",
                    controller: aadharCardController,
                    isRequired: true,
                  ),

                  UploadBox(
                    title: "Aadhar Card Image",
                    imageFile: _aadharCardImage,
                    onTap: _pickAadharImage,
                    onClear: () => setState(() => _aadharCardImage = null),
                    requiredField: true,
                  ),
                  SizedBox(height: 15.sp),
                  UploadBox(
                    title: "Student Image",
                    imageFile: _studentImage,
                    onTap: _pickStudentImage,
                    onClear: () => setState(() => _studentImage = null),
                    requiredField: true,
                  ),

                  SizedBox(height: 40.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        splashColor: AppColors.transparent,
                        highlightColor: AppColors.transparent,
                        onTap: () {
                          final firstName = firstNameController.text.trim();
                          final middleName = middleNameController.text.trim();
                          final lastName = lastNameController.text.trim();
                          final mobileNumber = mobileNumberController.text
                              .trim();
                          final emailId = emailController.text.trim();
                          final diagnosis = diagnosisController.text.trim();
                          final dob = selectedDate;
                          final genderId = int.parse(genderController.text);
                          final pidNumber =
                              int.tryParse(pidController.text) ?? 0;
                          final pinCode = pincodeController.text.trim();
                          final addressLine1 = addressLine1Controller.text
                              .trim();
                          final addressLine2 = addressLine2Controller.text
                              .trim();
                          final countryId = int.parse(countryController.text);
                          final stateId = int.parse(stateController.text);
                          final cityId = int.parse(cityController.text);
                          final nationalityId = int.parse(
                            nationalityController.text,
                          );
                          final aadharCardNumber = aadharCardController.text
                              .trim();

                          String? aadharCardImageName = _aadharCardImage?.path
                              .split('/')
                              .last;
                          String? studentImageName = _studentImage?.path
                              .split('/')
                              .last;

                          Provider.of<StudentDashboardProvider>(
                            context,
                            listen: false,
                          ).addStudent(
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
                            addressLine1: addressLine1.isEmpty
                                ? null
                                : addressLine1,
                            addressLine2: addressLine2.isEmpty
                                ? null
                                : addressLine2,
                            countryId: countryId,
                            stateId: stateId,
                            cityId: cityId,
                            nationalityId: nationalityId,
                            aadharCardNumber: aadharCardNumber,
                            aadharCardImageName: aadharCardImageName,
                            studentImageName: studentImageName,
                          );
                        },

                        child: CustomContainer(
                          text: 'Save And Continue',
                          fontWeight: FontWeight.w400,
                          padding: 5.sp,
                          innerPadding: EdgeInsets.symmetric(
                            horizontal: 18.sp,
                            vertical: 10.sp,
                          ),
                          borderRadius: 20.r,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
