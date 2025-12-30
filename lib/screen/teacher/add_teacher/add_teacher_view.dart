import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/screen/student/profile_detail/country_state_data_model.dart';
import 'package:special_education/screen/teacher/add_teacher/widgets/add_teacher_helper.dart';
import 'package:special_education/screen/teacher/teacher_dashboard_provider.dart';
import 'package:special_education/screen/teacher/teacher_data_model.dart';
import 'package:special_education/utils/image_upload_provider.dart';
import 'widgets/section_header.dart';
import 'widgets/form_text_field.dart';
import 'widgets/date_of_birth_picker.dart';
import 'widgets/upload_image_box.dart';
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
  List<RoleDataModal> _roles = [];

  int selectedCountryId = 0;
  int selectedStateId = 0;
  int selectedCityId = 0;
  int selectedNationality = 0;
  int selectedRoleId = 0;

  final helper = AddTeacherHelper();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    _countries = await helper.loadCountries();
    _roles = await helper.loadRoles();
    final imageProvider = Provider.of<ImageUploadProvider>(
      context,
      listen: false,
    );
    imageProvider.clearImage('teacher');
    imageProvider.clearImage('aadhar');
    imageProvider.clearImage('signature');
    setState(() {});
  }

  Future<void> _loadStates(String countryId) async {
    _states = await helper.loadStates(countryId);
    setState(() {});
  }

  Future<void> _loadCities(String stateId) async {
    _cities = await helper.loadCities(context, stateId);
    setState(() {});
  }

  void _submitForm() {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final mobileNumber = mobileNumberController.text.trim();
    final emailId = emailController.text.trim();
    final gender = genderController.text.trim();
    final pincode = pincodeController.text.trim();
    final employeeId = employeeIdController.text.trim();
    final country = countryController.text.trim();
    final state = stateController.text.trim();
    final city = cityController.text.trim();
    final role = roleIdController.text.trim();
    final nationality = nationalityController.text.trim();
    final aadharCard = aadharCardController.text.trim();
    final imageProvider = Provider.of<ImageUploadProvider>(
      context,
      listen: false,
    );

    if (firstName.isEmpty) {
      return showSnackBar("First name is required", context);
    }
    if (lastName.isEmpty) return showSnackBar("Last name is required", context);
    if (mobileNumber.isEmpty) {
      return showSnackBar("Mobile number is required", context);
    }
    if (mobileNumber.length < 10) {
      return showSnackBar("Mobile number is invalid", context);
    }
    if (emailId.isEmpty) return showSnackBar("Email is required", context);
    if (employeeId.isEmpty) return showSnackBar("Employee ID is required", context);
    if (country.isEmpty) return showSnackBar("Country is required", context);
    if (state.isEmpty) return showSnackBar("State is required", context);
    if (city.isEmpty) return showSnackBar("City is required", context);

    if (role.isEmpty) {
      return showSnackBar("Role is required", context);
    }
    if (nationality.isEmpty) {
      return showSnackBar("Nationality is required", context);
    }
    if (aadharCard.isNotEmpty) {
      if (aadharCard.length <12) {
        return showSnackBar("Aadhar card number is invalid", context);
      }
    }

    if (imageProvider.aadharImage?.path.isEmpty ?? true) {
      return showSnackBar("Aadhar card image is required", context);
    }

    if (imageProvider.teacherImage?.path.isEmpty ?? true) {
      return showSnackBar("Teacher image is required", context);
    }
    if (imageProvider.signatureImage?.path.isEmpty ?? true) {
      return showSnackBar("Signature image is required", context);
    }


    final provider = Provider.of<TeacherDashboardProvider>(
      context,
      listen: false,
    );


    provider.addAndUpdateTeacher(context,
      isUpdatingProfile: false,
      aadharCardImage: imageProvider.aadharImageUrl,
      aadharCardNumber: aadharCard,
      addressLine1: addressLine1Controller.text.trim(),
      addressLine2: addressLine2Controller.text.trim(),
      cityId: selectedCityId,
      countryId: selectedCountryId,
      dateOfBirth: selectedDate,
      emailId: emailController.text.trim().isEmpty
          ? null
          : emailController.text.trim(),
      employeeId: employeeIdController.text.trim(),
      firstName: firstName,
      genderId: gender == 'Male'
          ? 1
          : gender == 'Female'
          ? 2
          : 3,
      instituteId: 22,
      joiningDate: joiningDate,
      lastName: lastName,
      middleName: middleNameController.text.trim(),
      mobileNumber: mobileNumber,
      nationalityId: selectedNationality,
      pinCode: pincode,
      roleId: selectedRoleId,
      signature: imageProvider.signatureImageUrl,
      stateId: selectedStateId,
      image: imageProvider.teacherImageUrl,
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
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.sp),
            child: Column(
                children: [
                  SizedBox(height: 5.sp),
                  CustomHeaderView(courseName: "", moduleName: "Add New Teacher"),
                  Divider(thickness: 0.7.sp),
                ]
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.sp, vertical: 0.sp),
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
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
                      isRequired: true,
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
                      suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      onTap: () => helper.openGenderPicker(
                        context: context,
                        controller: genderController,
                      ),
                    ),
                    SizedBox(height: 10.sp),

                    // Address
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
                      onTap: () => helper.openCountryPicker(
                        context: context,
                        countries: _countries,
                        onCountrySelected: (country) {
                          countryController.text = country.countryName ?? '';
                          selectedCountryId = country.countryId ?? 0;
                          stateController.clear();
                          cityController.clear();
                          _loadStates(country.countryId.toString());
                        },
                      ),
                    ),
                    FormTextField(
                      label: "State",
                      controller: stateController,
                      isEditable: false,
                      isRequired: true,
                      suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      onTap: () => helper.openStatePicker(
                        context: context,
                        states: _states,
                        onStateSelected: (state) {
                          stateController.text = state.stateName ?? '';
                          selectedStateId = state.stateId ?? 0;
                          cityController.clear();
                          _loadCities(state.stateId.toString());
                        },
                      ),
                    ),
                    FormTextField(
                      label: "City/Town",
                      controller: cityController,
                      isEditable: false,
                      isRequired: true,
                      suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      onTap: () => helper.openCityPicker(
                        context: context,
                        cities: _cities,
                        onCitySelected: (city) {
                          cityController.text = city.cityName ?? '';
                          selectedCityId = city.cityId ?? 0;
                        },
                      ),
                    ),

                    SizedBox(height: 10.sp),
                    const SectionHeader(title: 'Employment Details'),
                    FormTextField(
                      label: "Role",
                      controller: roleIdController,
                      isEditable: false,
                      isRequired: true,
                      suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      onTap: () => helper.openRolePicker(
                        context: context,
                        roles: _roles,
                        onRoleSelected: (role) {
                          roleIdController.text = role.name ?? '';
                          selectedRoleId = role.id ?? 0;
                        },
                      ),
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
                      onTap: () => helper.openCountryPicker(
                        context: context,
                        countries: _countries,
                        onCountrySelected: (country) {
                          nationalityController.text =
                              country.countryName ?? '';
                          selectedNationality = country.countryId ?? 0;
                        },
                      ),
                    ),
                    FormTextField(
                      label: "Aadhar Card Number",
                      controller: aadharCardController,
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                    ),

                    UploadImageBox(
                      isUpdatingProfile: false,
                      title: "Aadhar Card Image",
                      requiredField: true,
                      imageFile: imageProvider.aadharImage,
                      onTap: () =>
                          imageProvider.pickAndUploadImage(context, 'aadhar'),
                      onClear: () => imageProvider.clearImage('aadhar'),
                    ),
                    SizedBox(height: 15.sp),
                    UploadImageBox(
                      isUpdatingProfile: false,
                      title: "Teacher Image",
                      requiredField: true,
                      imageFile: imageProvider.teacherImage,
                      onTap: () =>
                          imageProvider.pickAndUploadImage(context, 'teacher'),
                      onClear: () => imageProvider.clearImage('teacher'),
                    ),
                    SizedBox(height: 15.sp),
                    UploadImageBox(
                      isUpdatingProfile: false,
                      title: "Teacher Signature",
                      requiredField: true,
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
    employeeIdController.dispose();
    genderController.dispose();
    pincodeController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    roleIdController.dispose();
    nationalityController.dispose();
    aadharCardController.dispose();
    super.dispose();
  }
}
