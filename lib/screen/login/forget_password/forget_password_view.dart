import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/screen/login/forget_password/widget/create_password_view.dart';
import 'package:special_education/screen/login/forget_password/widget/send_otp_view.dart';
import 'package:special_education/screen/login/forget_password/widget/verify_otp_view.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String selectedOption = "mobile";

  int _step = 0;

  @override
  void dispose() {
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.themeColor,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(height: 15.sp),
              CustomHeaderView(courseName: '', moduleName: "Forget Password"),
              Divider(thickness: 1),
              SizedBox(height: 5.sp),

              if (_step == 0)
                SendOtpView(
                  selectedOption: selectedOption,
                  controller: otpController,
                  onOptionChanged: (value) {
                    setState(() {
                      selectedOption = value;
                      otpController.clear();
                    });
                  },
                  onSendTap: _validateAndSend,
                ),

              if (_step == 1)
                VerifyOtpView(
                  selectedOption: selectedOption,
                  controller: otpController,
                  onOptionChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                  onSendTap: _verifyOtp,
                ),

              if (_step == 2)
                CreatePasswordView(
                  passwordController: passwordController,
                  confirmPasswordController: confirmPasswordController,
                  onChangeTap: _changePassword,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateAndSend() {
    final input = otpController.text.trim();

    if (selectedOption == "email") {
      final emailReg = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
      if (!emailReg.hasMatch(input)) {
        showSnackBar("Please enter a valid email address", context);
        return;
      }
    } else {
      if (input.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(input)) {
        showSnackBar("Enter a valid 10-digit mobile number", context);
        return;
      }
    }

    // SUCCESS -> move to verify-OTP screen
    setState(() {
      _step = 1;
      otpController.clear();
    });

    showSnackBar("OTP Sent Successfully!", context, success: true);
  }

  void _verifyOtp() {
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      showSnackBar("Please enter a 6-digit OTP", context);
      return;
    }

    // TODO: call API to actually verify OTP

    setState(() {
      _step = 2; // move to create-password screen
    });

    showSnackBar("OTP Verified!", context, success: true);
  }

  void _changePassword() {
    final pass = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (pass.isEmpty || confirm.isEmpty) {
      showSnackBar("Password fields cannot be empty", context);
      return;
    }

    if (pass.length < 8) {
      showSnackBar("Password must be at least 8 characters", context);
      return;
    }

    if (pass != confirm) {
      showSnackBar("Passwords do not match", context);
      return;
    }

    // TODO: call API to update password

    showSnackBar("Password changed successfully!", context, success: true);
  }
}
