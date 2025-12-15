import 'dart:io';

import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/components/custom_api_call.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_dropdown_form_field.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/custom_widget/custom_image_picker_preview.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/field_label_row.dart';
import 'package:special_education/custom_widget/text_field.dart';
import 'package:special_education/screen/student/profile_detail/country_state_data_model.dart';
import 'package:special_education/screen/teacher/add_teacher/widgets/add_teacher_helper.dart';
import 'package:special_education/screen/teacher/add_teacher/widgets/role_picker_modal.dart';
import 'package:special_education/screen/teacher/teacher_data_model.dart' show RoleDataModal;
import 'package:special_education/screen/top_right_button/my_profile/my_profile_data_model.dart';
import 'package:special_education/screen/top_right_button/my_profile/update_my_profile/update_my_profile_provider.dart';
import 'package:special_education/utils/custom_function_utils.dart';

import '../../../student/profile_detail/add_student/widgets/city_picker_modal.dart';
import '../../../student/profile_detail/add_student/widgets/country_picker_modal.dart';
import '../../../student/profile_detail/add_student/widgets/date_of_birth_picker.dart';
import '../../../student/profile_detail/add_student/widgets/state_picker_modal.dart';

class UpdateMyProfileView extends StatefulWidget {
  final MyProfileDataModel profile;
  const UpdateMyProfileView({super.key, required this.profile});

  @override
  State<UpdateMyProfileView> createState() => _UpdateMyProfileViewState();
}

class _UpdateMyProfileViewState extends State<UpdateMyProfileView> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController empIdController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityTownController = TextEditingController();

  final TextEditingController designationController = TextEditingController();
  final TextEditingController joiningDateController = TextEditingController();

  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController aadharCardNumberController =
      TextEditingController();

  late final ValueNotifier<File?> studentImageNotifier;
  late final ValueNotifier<File?> aadhaarImageFrontNotifier;
  late final ValueNotifier<File?> aadhaarImageBackNotifier;
  late final ValueNotifier<String?> studentUploadedFileNameNotifier;
  late final ValueNotifier<String?> aadhaarFrontUploadedFileNameNotifier;
  late final ValueNotifier<String?> aadhaarBackUploadedFileNameNotifier;

  var updateGender = [
    {'id': 1, 'status': "Male"},
    {'id': 2, 'status': "Female"},
    {'id': 3, 'status': "Others"},
  ];

  String? selectedGender;

  @override
  void initState() {
    super.initState();

    // All synchronous assignments
    firstNameController.text = setNA(widget.profile.firstName);
    middleNameController.text = setNA(widget.profile.middleName);
    lastNameController.text = setNA(widget.profile.lastName);
    mobileController.text = setNA(widget.profile.mobileNumber);
    emailController.text = setNA(widget.profile.emailId);
    empIdController.text = setNA(widget.profile.employeeId);
    dobController.text = setNA(widget.profile.dateOfBirth);
    genderController.text = setNA(widget.profile.gender);

    selectedGender = genderController.text.isNotEmpty
        ? genderController.text
        : null;

    pincodeController.text = setNA(widget.profile.pinCode.toString());
    addressLine1Controller.text = setNA(widget.profile.addressLine1);
    addressLine2Controller.text = setNA(widget.profile.addressLine2);
    countryController.text = setNA(widget.profile.countryName);
    stateController.text = setNA(widget.profile.state);
    cityTownController.text = setNA(widget.profile.cityName);

    designationController.text = setNA(widget.profile.designation);
    joiningDateController.text = setNA(widget.profile.joiningDate);

    nationalityController.text = setNA(widget.profile.nationality);
    aadharCardNumberController.text = setNA(widget.profile.adharCardNumber);

    studentImageNotifier = ValueNotifier<File?>(null);
    aadhaarImageFrontNotifier = ValueNotifier<File?>(null);
    aadhaarImageBackNotifier = ValueNotifier<File?>(null);

    studentUploadedFileNameNotifier = ValueNotifier<String?>(null);
    aadhaarFrontUploadedFileNameNotifier = ValueNotifier<String?>(null);
    aadhaarBackUploadedFileNameNotifier = ValueNotifier<String?>(null);
    loadInitialData();
  }


  Future<void> loadInitialData() async {
    await loadCountries();
    _roles = await helper.loadRoles();
    setState(() {});
  }


  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    empIdController.dispose();
    dobController.dispose();
    genderController.dispose();

    pincodeController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    countryController.dispose();
    stateController.dispose();
    cityTownController.dispose();

    designationController.dispose();
    joiningDateController.dispose();

    nationalityController.dispose();
    aadharCardNumberController.dispose();

    studentImageNotifier.dispose();
    aadhaarImageFrontNotifier.dispose();
    aadhaarImageBackNotifier.dispose();
    studentUploadedFileNameNotifier.dispose();
    aadhaarFrontUploadedFileNameNotifier.dispose();
    aadhaarBackUploadedFileNameNotifier.dispose();

    super.dispose();
  }
  final locationService = LocationService();

  List<CountryDataModal> _countries = [];
  List<StateDataModel> _states = [];
  List<CityDataModel> _cities = [];
  List<RoleDataModal> _roles = [];

  int selectedCountryId = 0;
  int selectedStateId = 0;
  int selectedCityId = 0;
  int selectedNationality = 0;
  int selectedRoleId = 0;

  DateTime selectedDate = DateTime.now();
  DateTime joiningDate = DateTime.now();

  final helper = AddTeacherHelper();

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

  void _openCountryPicker({required bool isNationality}) {
    if (_countries.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Loading countries, please wait..."))
      );
      return;
    }
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
            cityTownController.clear();
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
          cityTownController.clear();
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
          cityTownController.text = city.cityName ?? '';
          selectedCityId = city.cityId ?? 0;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.sp),
            child: Column(
              children: [
                SizedBox(height: 5.sp),
                CustomHeaderView(
                  backIconColor: AppColors.themeColor,
                  courseName: 'Profile',
                  primaryColor: AppColors.darkGrey,
                  moduleName: "Update Profile Details",
                ),
                Divider(thickness: 0.7.sp, color: AppColors.themeColor),
              ],
            ),
          ),
          backgroundColor: AppColors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 20.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "General Information",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  Divider(thickness: 0.5.sp, color: AppColors.darkGrey),
                  SizedBox(height: 10.sp),

                  FieldLabel(text: "First Name", isRequired: true),
                  SizedBox(height: 3.sp),
                  CustomTextField(
                    fontSize: 13.sp,
                    controller: firstNameController,
                    borderRadius: 5.r,
                    borderColor: Colors.grey,
                    fillColor: Colors.grey.shade200,
                    isEditable: true,
                  ),
                  SizedBox(height: 2.sp),

                  FieldLabel(text: "Middle Name"),
                  SizedBox(height: 3.sp),
                  CustomTextField(
                    fontSize: 13.sp,
                    controller: middleNameController,
                    borderRadius: 5,
                    borderColor: Colors.grey,
                    fillColor: Colors.grey.shade200,
                    isEditable: true,
                  ),
                  SizedBox(height: 2.sp),

                  FieldLabel(text: "Last Name", isRequired: true),
                  SizedBox(height: 3.sp),
                  CustomTextField(
                    fontSize: 13.sp,
                    controller: lastNameController,
                    borderRadius: 5,
                    borderColor: Colors.grey,
                    fillColor: Colors.grey.shade200,
                    isEditable: true,
                  ),
                  SizedBox(height: 2.sp),

                  FieldLabel(text: "Mobile", isRequired: true),
                  SizedBox(height: 3.sp),
                  CustomTextField(
                    fontSize: 13.sp,
                    controller: mobileController,
                    borderRadius: 5,
                    borderColor: Colors.grey,
                    fillColor: Colors.grey.shade200,
                    isEditable: true,
                  ),
                  SizedBox(height: 2.sp),

                  FieldLabel(text: "Email Id", isRequired: true),
                  SizedBox(height: 3.sp),
                  CustomTextField(
                    fontSize: 13.sp,
                    controller: emailController,
                    borderRadius: 5,
                    borderColor: Colors.grey,
                    fillColor: Colors.grey.shade200,
                    isEditable: true,
                    isEmail: true,
                  ),
                  SizedBox(height: 2.sp),

                  FieldLabel(text: "Employee ID", isRequired: true),
                  SizedBox(height: 3.sp),
                  CustomTextField(
                    fontSize: 13.sp,
                    controller: empIdController,
                    borderRadius: 5,
                    borderColor: Colors.grey,
                    fillColor: Colors.grey.shade200,
                    isEditable: true,
                  ),
                  SizedBox(height: 2.sp),

                  DateOfBirthPicker(
                    selectedDate: selectedDate,
                    onChanged: (date) => setState(() => selectedDate = date),
                  ),

                  SizedBox(height: 5.sp),

                  FieldLabel(text: "Gender", isRequired: true),
                  SizedBox(height: 3.sp),
                  CustomDropdownFormField(
                    items: updateGender,
                    selectedValue: selectedGender,
                    hintText: 'Select Gender',
                    controller: genderController,
                    onChanged: (value) {
                      selectedGender = value;
                    },
                  ),
                  SizedBox(height: 30.sp),
                  CustomText(
                    text: "Address Details",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  Divider(thickness: 0.5.sp, color: AppColors.darkGrey),
                  SizedBox(height: 10.sp),

                  FieldLabel(text: "Pincode"),
                  SizedBox(height: 3.sp),
                  CustomTextField(
                    fontSize: 13.sp,
                    controller: pincodeController,
                    borderRadius: 5.r,
                    borderColor: Colors.grey,
                    fillColor: Colors.grey.shade200,
                    isEditable: true,
                  ),
                  SizedBox(height: 2.sp),

                  FieldLabel(text: "Address Line 1"),
                  SizedBox(height: 3.sp),
                  CustomTextField(
                    fontSize: 13.sp,
                    controller: addressLine1Controller,
                    borderRadius: 5,
                    borderColor: Colors.grey,
                    fillColor: Colors.grey.shade200,
                    isEditable: true,
                  ),
                  SizedBox(height: 2.sp),

                  FieldLabel(text: "Address Line 2"),
                  SizedBox(height: 3.sp),
                  CustomTextField(
                    fontSize: 13.sp,
                    controller: addressLine2Controller,
                    borderRadius: 5,
                    borderColor: Colors.grey,
                    fillColor: Colors.grey.shade200,
                    isEditable: true,
                  ),
                  SizedBox(height: 2.sp),

                  FieldLabel(text: "Country", isRequired: true),
                  SizedBox(height: 3.sp),
                  CustomTextField(
                    fontSize: 13.sp,
                    controller: countryController,
                    borderRadius: 5,
                    borderColor: Colors.grey,
                    fillColor: Colors.grey.shade200,
                    isEditable: false,
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                    onTap: () => _openCountryPicker(isNationality: false),
                  ),
                  SizedBox(height: 2.sp),

                  FieldLabel(text: "State", isRequired: true),
                  SizedBox(height: 3.sp),
                  CustomTextField(
                    fontSize: 13.sp,
                    controller: stateController,
                    borderRadius: 5,
                    borderColor: Colors.grey,
                    fillColor: Colors.grey.shade200,
                    isEditable: false,
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                    onTap: _openStatePicker,
                  ),
                  SizedBox(height: 2.sp),

                  FieldLabel(text: "City/Town", isRequired: true),
                  SizedBox(height: 3.sp),
                  CustomTextField(
                    fontSize: 13.sp,
                    controller: cityTownController,
                    borderRadius: 5,
                    borderColor: Colors.grey,
                    fillColor: Colors.grey.shade200,
                    isEditable: false,
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                    onTap: _openCityPicker,
                  ),


                  SizedBox(height: 20.sp),
                  CustomText(
                    text: "Employment Details",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  Divider(thickness: 0.5.sp, color: AppColors.darkGrey),
                  SizedBox(height: 10.sp),

                  FieldLabel(text: "Designation"),
                  SizedBox(height: 3.sp),
                  CustomTextField(
                    fontSize: 13.sp,
                    controller: designationController,
                    borderRadius: 5.r,
                    borderColor: Colors.grey,
                    fillColor: Colors.grey.shade200,
                    isEditable: true,
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                    onTap: () => helper.openRolePicker(
                      context: context,
                      roles: _roles,
                      onRoleSelected: (role) {
                        designationController.text = role.name ?? '';
                        selectedRoleId = role.id ?? 0;
                      },
                    ),
                  ),
                  SizedBox(height: 2.sp),


                  SizedBox(height: 3.sp),

                  DateOfBirthPicker(
                    isRequired: false,
                    label: "Joining Date",
                    selectedDate: joiningDate,
                    onChanged: (date) => setState(() => joiningDate = date),
                  ),


                  SizedBox(height: 20.sp),
                  CustomText(
                    text: "Additional Details",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  Divider(thickness: 0.5.sp, color: AppColors.darkGrey),
                  SizedBox(height: 10.sp),

                  FieldLabel(text: "Nationality", isRequired: true),
                  SizedBox(height: 3.sp),
                  CustomTextField(
                    fontSize: 13.sp,
                    controller: nationalityController,
                    borderRadius: 5.r,
                    borderColor: Colors.grey,
                    fillColor: Colors.grey.shade200,
                    isEditable: false,
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                    onTap: () => _openCountryPicker(isNationality: true),
                  ),
                  SizedBox(height: 2.sp),

                  FieldLabel(text: "Aadhar Card Number", isRequired: true),
                  SizedBox(height: 3.sp),
                  CustomTextField(
                    fontSize: 13.sp,
                    maxLength: 12,
                    keyboardType: TextInputType.number,
                    controller: aadharCardNumberController,
                    borderRadius: 5,
                    borderColor: Colors.grey,
                    fillColor: Colors.grey.shade200,
                    isEditable: true,
                  ),

                  SizedBox(height: 2.sp),

                  SizedBox(height: 10.h),
                  FieldLabel(text: "Student Image"),
                  SizedBox(height: 3.sp),
                  ImagePickerWithPreview(
                    imageFileNotifier: studentImageNotifier,
                    imageUrl: '${ApiServiceUrl.urlLauncher}Documents/${widget.profile.image}',
                    uploadButtonText: "Upload Image",
                    containerHeight: 40,
                    thumbnailHeight: 120,
                    thumbnailWidth: 200,
                    fullscreenHeight: 500,
                    bottomSheetTitle: 'Update Student Image',
                    uploadedFileNameNotifier: studentUploadedFileNameNotifier,
                  ),
                  SizedBox(height: 20.h),

                  FieldLabel(text: "Aadhar Card Image"),
                  SizedBox(height: 3.sp),
                  ImagePickerWithPreview(
                    imageFileNotifier: aadhaarImageFrontNotifier,
                    imageUrl:
                    '${ApiServiceUrl.urlLauncher}Documents/${widget.profile.adharCardImage}',
                    uploadButtonText: "Upload Image",
                    containerHeight: 40,
                    thumbnailHeight: 120,
                    thumbnailWidth: 200,
                    fullscreenHeight: 500,
                    bottomSheetTitle: 'Update Aadhar Card Image',
                    uploadedFileNameNotifier:
                        aadhaarFrontUploadedFileNameNotifier,
                  ),

                  SizedBox(height: 20.h),

                  FieldLabel(text: "Aadhar Card Image"),
                  SizedBox(height: 3.sp),
                  ImagePickerWithPreview(
                    imageFileNotifier: aadhaarImageBackNotifier,
                    imageUrl:
                    '${ApiServiceUrl.urlLauncher}Documents/${widget.profile.adharCardImage}',
                    uploadButtonText: "Upload Image",
                    containerHeight: 40,
                    thumbnailHeight: 120,
                    thumbnailWidth: 200,
                    fullscreenHeight: 500,
                    bottomSheetTitle: 'Update Aadhar Card Image',
                    uploadedFileNameNotifier: aadhaarBackUploadedFileNameNotifier,
                  ),
                  SizedBox(height: 70.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        splashColor: AppColors.transparent,
                        highlightColor: AppColors.transparent,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.darkGrey,
                              width: 0.7.sp
                            ),
                            borderRadius: BorderRadius.circular(5.sp)
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.sp,vertical: 5.sp),
                            child: CustomText(text: 'Cancel',color: AppColors.darkGrey,),
                          ),
                        ),
                      ),
                      SizedBox(width: 20.sp,),
                      InkWell(
                        splashColor: AppColors.transparent,
                        highlightColor: AppColors.transparent,
                        onTap: () {
                          final provider = Provider.of<UpdateMyProfileProvider>(context, listen: false);
                          provider.updateMyProfile(
                            context,
                            firstName: firstNameController.text,
                            middleName: middleNameController.text,
                            lastName: lastNameController.text,
                            mobileNumber: mobileController.text,
                            emailId: emailController.text,
                            employeeId: empIdController.text,
                            dateOfBirth: dobController.text,
                            genderId: selectedGender == "Male" ? 1 : selectedGender == "Female" ? 2 : 3,
                            pinCode: pincodeController.text,
                            addressLine1: addressLine1Controller.text,
                            addressLine2: addressLine2Controller.text,
                            countryId: selectedCountryId,
                            stateId: selectedStateId,
                            cityId: selectedCityId,
                            designation: designationController.text,
                            roleId: selectedRoleId,
                            joiningDate: joiningDateController.text,
                            nationalityId: selectedNationality,
                            aadharCardNumber: aadharCardNumberController.text,
                            studentImage: studentUploadedFileNameNotifier.value ?? widget.profile.image ?? '',
                            aadharCardImage: aadhaarFrontUploadedFileNameNotifier.value ?? widget.profile.adharCardImage ?? '',
                            signature: aadhaarBackUploadedFileNameNotifier.value ?? widget.profile.adharCardImage ?? '',
                          );
                        },

                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.yellow,
                            borderRadius: BorderRadius.circular(5.sp)
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.sp,vertical: 6.sp),
                            child: CustomText(text: 'Update Profile',color: AppColors.white,),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
