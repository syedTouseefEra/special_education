import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:special_education/constant/assets.dart';
import 'package:special_education/constant/colors.dart';
import 'package:special_education/custom_widget/custom_text.dart';
import 'package:special_education/screen/login/login_view.dart';
import 'package:special_education/utils/navigation_utils.dart';

void alertToast(String message) {
  Fluttertoast.showToast(msg: message);
}

void showSnackBar(String message, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
    ),
  );
}

void doubleButton(
    BuildContext context,
    String? title,
    String message,
    Function yesPressEvent,
    ) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) { // ✅ safe dialog context
      return Material(
        color: Colors.transparent,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.sp),
                color: Colors.white,
              ),
              width: MediaQuery.sizeOf(context).width,
              child: Padding(
                padding: EdgeInsets.all(8.sp),
                child: Stack(
                  alignment: const AlignmentDirectional(0, -1.6),
                  children: [
                    Image.asset(
                      ImgAssets.cancelIcon, // replace with your image
                      height: 50.h,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 10.sp),
                        CustomText(text: title ?? "", fontSize: 18.sp, fontWeight: FontWeight.w500, color: AppColors.darkGrey),

                        Padding(
                          padding: EdgeInsets.fromLTRB(8.sp, 0.sp, 8.sp, 8.sp,),
                          child: CustomText(
                            textAlign: TextAlign.center,
                            text: message,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkGrey,
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(dialogContext);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 45.sp,
                                  vertical: 5.sp,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1.sp,
                                    color: AppColors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(20.sp),
                                ),
                                child: CustomText(
                                  text: "Cancel",
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 25.sp),

                            InkWell(
                              onTap: () {
                                Navigator.pop(dialogContext);
                                yesPressEvent();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 45.sp,
                                  vertical: 7.sp,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.red,
                                  borderRadius: BorderRadius.circular(20.sp),
                                ),
                                child: CustomText(
                                  text: "Delete",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Roboto',
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 70.sp),
                          ],
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
    },
  );
}


void unauthorizedUser(dynamic context){
  showSnackBar("Session expired. Please login again.", context);
  Future.delayed(const Duration(milliseconds: 500), () {
    NavigationHelper.pushAndClearStack(context, LoginPage());
  });
}