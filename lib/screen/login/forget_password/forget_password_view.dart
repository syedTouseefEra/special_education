import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart' show Provider;
import 'package:special_education/components/alert_view.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_header_view.dart';
import 'package:special_education/screen/login/forget_password/forget_password_provider.dart';
import 'package:special_education/screen/login/forget_password/widget/create_password_view.dart';
import 'package:special_education/screen/login/forget_password/widget/send_otp_view.dart';
import 'package:special_education/screen/login/forget_password/widget/verify_otp_view.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {

  final TextEditingController contactController = TextEditingController(); // mobile/email input
  final TextEditingController otpController = TextEditingController();     // OTP input
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String selectedOption = "mobile";
  String? _sentContact; // store the contact used to generate OTP

  int _step = 0;
  bool _isLoading = false; // optional loading flag


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
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 15.sp),
                  CustomHeaderView(courseName: '', moduleName: "Forget Password"),
                  Divider(thickness: 1),
                  SizedBox(height: 5.sp),

                  if (_step == 0)
                    SendOtpView(
                      selectedOption: selectedOption,
                      controller: contactController,
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
                      setStep: () {
                        setState(() {
                          _step = 0;
                        });
                      },
                    ),

                  if (_step == 2)
                    CreatePasswordView(
                      passwordController: passwordController,
                      confirmPasswordController: confirmPasswordController,
                      onChangeTap: _changePassword,
                      setStep: () {
                        setState(() {
                          _step = 0;
                          passwordController.clear();
                          confirmPasswordController.clear();
                        });
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

  void _validateAndSend() async {
    final input = contactController.text.trim();

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

    final provider = Provider.of<ForgetPasswordProvider>(context, listen: false);

    setState(() => _isLoading = true);
    try {
      // Await the provider call (make sure generateOtp returns Future<bool>)
      final sent = await provider.generateOtp(input, context);

      if (sent == true) {
        // Save the contact so verifyOtp can use it later
        setState(() {
          _sentContact = input;
          _step = 1;
        });
        // Clear the OTP controller (so Verify screen is empty) but keep contactController if you want
        otpController.clear();
      } else {
        // provider should show snackbar with message; no UI change
      }
    } catch (e) {
      showSnackBar("Failed to send OTP: ${e.toString()}", context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _verifyOtp() async {
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      showSnackBar("Please enter a 6-digit OTP", context);
      return;
    }

    if (_sentContact == null || _sentContact!.isEmpty) {
      // fallback: read from contactController if not set
      showSnackBar("No contact found — please request OTP again", context);
      return;
    }

    final provider = Provider.of<ForgetPasswordProvider>(context, listen: false);

    setState(() => _isLoading = true);
    try {
      final success = await provider.verifyOtp(_sentContact!, otp, context);

      if (success) {
        setState(() {
          _step = 2;
        });
        otpController.clear();
        // provider already shows success message; optionally show another
      } else {
        // provider shows failure message (per your implementation)
      }
    } catch (e) {
      showSnackBar("OTP verification failed: ${e.toString()}", context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _changePassword() async {
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

    final provider = Provider.of<ForgetPasswordProvider>(context, listen: false);

    setState(() => _isLoading = true);
    try {
      final success = await provider.forgotPassword(pass, context);

      if (success) {
        setState(() {
          _step = 2;
        });
        otpController.clear();
        // provider already shows success message; optionally show another
      } else {
        // provider shows failure message (per your implementation)
      }
    } catch (e) {
      showSnackBar("Password verification failed: ${e.toString()}", context);
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
