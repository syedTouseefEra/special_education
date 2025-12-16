import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/constant/assets.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/button.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/custom_widget/text_field.dart';
import 'package:special_education/screen/login/forget_password/forget_password_view.dart';
import 'package:special_education/screen/login/login_provider.dart';
import 'package:special_education/screen/registration/registration_view.dart';
import 'package:special_education/utils/navigation_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: "7007552754");
  // final _usernameController = TextEditingController(text: "9369997878");
  final _passwordController = TextEditingController(text: "Abc@123");
  bool isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<LoginProvider>(context, listen: false);

      final success = await authProvider.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
        context,
      );

      if (success && mounted) {
        if (mounted) {
          showSnackBar("Login successfully", context);
        }
      } else {
        if (mounted) {
          showSnackBar("Login failed", context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<LoginProvider>(context);

    return Container(
      color: AppColors.themeBlue,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Image.asset(ImgAssets.blueBg),
                    Padding(
                      padding: EdgeInsets.only(top: 30.w),
                      child: Center(
                        child: Image.asset(ImgAssets.eduCap, width: 200.w),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                CustomText(
                  text: 'Welcome Back!',
                  fontSize: 25.h,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'DMSerif',
                  color: AppColors.themeBlue,
                ),
                SizedBox(height: 40.h),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        child: CustomTextField(
                          fontSize: 18.sp,
                          must: false,
                          obscureText: false,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          controller: _usernameController,
                          label: 'Mobile no.',
                        ),
                      ),
                      SizedBox(height: 20.sp),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        child: CustomTextField(
                          fontSize: 18.sp,
                          maxLines: 1,
                          controller: _passwordController,
                          label: 'Password',
                          obscureText: !isPasswordVisible,
                          suffixIcon: IconButton(
                            icon: Padding(
                              padding: EdgeInsets.only(right: 15.w),
                              child: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.themeColor,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25.h),

                if (authProvider.error != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: Text(
                      authProvider.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                SizedBox(height: 10),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: CustomButton(
                    text: authProvider.isLoading ? "Logging in..." : "Login",

                    onPressed: authProvider.isLoading
                        ? null
                        : () => _login(context),
                    isLoading: authProvider.isLoading,
                    width: double.infinity,
                    height: 45.h,
                    backgroundColor: AppColors.themeBlue,
                    textColor: AppColors.white,
                    fontSize: 16.h,
                    borderRadius: 30.sp,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.sp,
                      vertical: 12.sp,
                    ),
                  ),
                ),
                SizedBox(height: 25.sp),
                InkWell(
                  splashColor: AppColors.transparent,
                  highlightColor: AppColors.transparent,
                  onTap: () {
                    NavigationHelper.push(context, ForgetPasswordView());
                  },
                  child: CustomText(text: "Forget Password?"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 25.sp,
                    horizontal: 30.sp,
                  ),
                  child: Divider(thickness: 1.sp),
                ),
                InkWell(
                  splashColor: AppColors.transparent,
                  highlightColor: AppColors.transparent,
                  onTap: () {
                    NavigationHelper.push(context, RegistrationView());
                  },
                  child: CustomText(text: "Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
