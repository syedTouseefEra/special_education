import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/components/custom_appbar.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_container.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/screen/choose_account/choose_account_provider.dart';
import 'package:special_education/screen/choose_account/choose_account_data_model.dart';
import 'package:special_education/screen/login/login_view.dart';
import 'package:special_education/screen/tabbar_view.dart';
import 'package:special_education/screen/top_right_button/top_option_sheet_view.dart';
import 'package:special_education/user_data/user_data.dart';
import 'package:special_education/utils/navigation_utils.dart';
import 'package:special_education/utils/text_case_utils.dart';

class ChooseAccountView extends StatefulWidget {
  final List<ChooseAccountDataModel> chooseAccountData;

  const ChooseAccountView({super.key, required this.chooseAccountData});

  @override
  State<ChooseAccountView> createState() => _ChooseAccountViewState();
}

class _ChooseAccountViewState extends State<ChooseAccountView> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    final filteredData = widget.chooseAccountData
        .where((data) => data.userId == 10 && data.organizationTypeId == 4)
        .toList();

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {},
      child: Container(
        color: AppColors.themeColor,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: SingleChildScrollView(
              child: filteredData.isEmpty
                  ? const Center(child: Text("No students found"))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.sp,),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.sp,
                            vertical: 5.sp,
                          ),
                          child: CustomText(
                            text:
                                "Select an Account Mr. ${name.isEmpty ? "User" : name}",
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'DM Serif',
                            color: AppColors.black,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.sp),
                          child: CustomText(
                            text:
                                "Choose from the list of your existing account",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textGrey,
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            UserData().removeUserData();
                            NavigationHelper.pushAndClearStack(
                              context,
                              LoginPage(),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.sp),
                            child: CustomContainer(
                              textCase: TextCase.upper,
                              padding: 8.sp,
                              innerPadding: EdgeInsets.symmetric(
                                horizontal: 25.sp,
                                vertical: 5.sp,
                              ),
                              containerColor: AppColors.yellow,
                              text: 'Logout',
                              textColor: AppColors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredData.length,
                          padding: EdgeInsets.symmetric(horizontal: 15.sp),
                          itemBuilder: (context, index) {
                            final data = filteredData[index];
                            name = data.name ?? '';

                            return Container(
                              margin: EdgeInsets.only(bottom: 12.sp),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.sp),
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.textGrey,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  final provider =
                                      Provider.of<ChooseAccountProvider>(
                                        context,
                                        listen: false,
                                      );

                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );

                                  try {
                                    bool success = await provider
                                        .getDataByInstitute(
                                          organizationId: data.organizationId!,
                                          instituteId: data.instituteId!,
                                          userRoleId: data.userRoleId!,
                                        );

                                    Navigator.of(context).pop();

                                    if (success) {
                                      NavigationHelper.replacePush(
                                        context,
                                        const HomeScreen(),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            provider.error ??
                                                "Failed to select account",
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error: ${e.toString()}'),
                                      ),
                                    );
                                  }
                                },

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width,
                                      child: CustomContainer(
                                        textCase: TextCase.title,
                                        padding: 8.sp,
                                        innerPadding: EdgeInsets.symmetric(
                                          horizontal: 15.sp,
                                          vertical: 8.sp,
                                        ),
                                        containerColor: AppColors.yellow,
                                        text:
                                            data.instituteName?.isEmpty ?? true
                                            ? 'NA'
                                            : data.instituteName!,
                                        textColor: AppColors.white,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomContainer(
                                          textCase: TextCase.upper,
                                          padding: 8.sp,
                                          innerPadding: EdgeInsets.symmetric(
                                            horizontal: 15.sp,
                                            vertical: 8.sp,
                                          ),
                                          containerColor: AppColors.yellow,
                                          text: getInitials(data.name ?? ''),
                                          textColor: AppColors.white,
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                textCase: TextCase.title,
                                                text: data.name ?? "User",
                                                fontSize: 16.sp,
                                              ),
                                              CustomText(
                                                textCase: TextCase.title,
                                                text:
                                                    data.userId?.toString() ??
                                                    "N/A",
                                                fontSize: 15.sp,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            bottom: 10.sp,
                                          ),
                                          child: CustomContainer(
                                            innerPadding: EdgeInsets.symmetric(
                                              horizontal: 15.sp,
                                              vertical: 5.sp,
                                            ),
                                            borderWidth: 1.sp,
                                            borderColor: AppColors.yellow,
                                            containerColor: AppColors.white,
                                            text: data.roleName ?? "Role",
                                            textColor: AppColors.yellow,
                                            textAlign: TextAlign.center,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.sp),
                                    Container(
                                      width: MediaQuery.sizeOf(context).width,
                                      height: 1.sp,
                                      color: AppColors.textGrey,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.sp),
                                      child: CustomText(
                                        textCase: TextCase.title,
                                        text: data.organizationName ?? 'N/A',
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
