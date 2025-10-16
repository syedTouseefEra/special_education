// import 'dart:io';
//
// import 'package:special_education/api_service/api_service_url.dart';
// import 'package:special_education/components/alert_view.dart';
// import 'package:special_education/constant/colors.dart';
// import 'package:special_education/custom_widget/custom_text.dart';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:special_education/custom_widget/field_label_row.dart';
// import 'package:special_education/utils/custom_function_utils.dart';
// import 'package:special_education/utils/image_picker.dart';
// import 'package:special_education/utils/navigation_utils.dart';
// import 'package:special_education/utils/text_case_utils.dart';
//
// class ImagePickerWithPreview extends StatelessWidget {
//   final ValueNotifier<File?> imageFileNotifier;
//   final ValueNotifier<String?> uploadedFileNameNotifier;
//   final String? imageUrl;
//   final String uploadButtonText;
//   final double containerHeight;
//   final double thumbnailHeight;
//   final double thumbnailWidth;
//   final double fullscreenHeight;
//   final String bottomSheetTitle;
//   final WidgetRef ref;
//
//   const ImagePickerWithPreview({
//     required this.imageFileNotifier,
//     required this.uploadedFileNameNotifier,
//     this.imageUrl,
//     required this.uploadButtonText,
//     required this.containerHeight,
//     required this.thumbnailHeight,
//     required this.thumbnailWidth,
//     required this.fullscreenHeight,
//     required this.bottomSheetTitle,
//     required this.ref,
//     super.key,
//   });
//
//   void _showImagePickerModal(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
//       ),
//       builder: (BuildContext context) {
//         return Padding(
//           padding: EdgeInsets.all(15.sp),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(height: 5.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     onTap: () => Navigator.pop(context),
//                     child: Icon(Icons.cancel_outlined,
//                         color: Colors.black, size: 20.h),
//                   ),
//                   CustomText(
//                     textAlign: TextAlign.start,
//                     text: bottomSheetTitle,
//                     fontSize: 20.sp,
//                     fontFamily: 'DMSerif',
//                     fontWeight: FontWeight.w400,
//                     color: AppColors.black,
//                   ),
//                   Icon(Icons.delete_outline,
//                       color: Colors.transparent, size: 20.h),
//                 ],
//               ),
//               SizedBox(height: 20.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   // GALLERY
//                   InkWell(
//                     onTap: () async {
//                       Navigator.pop(context);
//                       await Future.delayed(Duration(milliseconds: 300));
//                       final pickedFile =
//                           await ImagePickerHelper.pickFromGallery();
//
//                       if (pickedFile != null) {
//                         final fileSize = await pickedFile.length();
//
//                         if (fileSize > 5 * 1024 * 1024) {
//                           AlertView().alertToast(
//                               "Image exceeds 5 MB limit. Please select a smaller one");
//                           return;
//                         }
//                         final uploadedFileName =
//                             await ImageUploaderHelper.uploadProfileImage(
//                           ref: ref,
//                           filePath: pickedFile.path,
//                           context: context, folderId: '1',
//                         );
//
//                         if (uploadedFileName != null) {
//                           imageFileNotifier.value = File(pickedFile.path);
//                           uploadedFileNameNotifier.value = uploadedFileName;
//                           print("Uploaded filenamewwwee: $uploadedFileName");
//                         }
//                       }
//                     },
//                     child: Column(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(2.h),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.grey, width: 1.w),
//                           ),
//                           child: CircleAvatar(
//                             radius: 15.h,
//                             backgroundColor: Colors.grey.shade200,
//                             child: Icon(Icons.photo_library,
//                                 color: AppColors.themeColor, size: 20.h),
//                           ),
//                         ),
//                         SizedBox(height: 8.h),
//                         Text("Gallery", style: TextStyle(fontSize: 14.sp)),
//                       ],
//                     ),
//                   ),
//
//                   // CAMERA
//                   InkWell(
//                     onTap: () async {
//                       Navigator.pop(context);
//                       await Future.delayed(Duration(milliseconds: 300));
//                       final pickedFile =
//                           await ImagePickerHelper.pickFromCamera();
//
//                       if (pickedFile != null) {
//                         final fileSize = await pickedFile.length();
//
//                         if (fileSize > 5 * 1024 * 1024) {
//                           AlertView().alertToast(
//                               "Image exceeds 5 MB limit. Please select a smaller one");
//                           return;
//                         }
//                         final uploadedFileName =
//                             await ImageUploaderHelper.uploadProfileImage(
//                           ref: ref,
//                           filePath: pickedFile.path,
//                           context: context, folderId: '1',
//                         );
//
//                         if (uploadedFileName != null) {
//                           imageFileNotifier.value = File(pickedFile.path);
//                           uploadedFileNameNotifier.value = uploadedFileName;
//                         }
//                       }
//                     },
//                     child: Column(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(2.h),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.grey, width: 1.w),
//                           ),
//                           child: CircleAvatar(
//                             radius: 15.h,
//                             backgroundColor: Colors.grey.shade200,
//                             child: Icon(Icons.camera_alt,
//                                 color: AppColors.themeColor, size: 20.h),
//                           ),
//                         ),
//                         SizedBox(height: 8.h),
//                         Text("Camera", style: TextStyle(fontSize: 14.sp)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20.h),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void _showFullScreenImage(BuildContext context, widget imageWidget) {
//     showDialog(
//       context: context,
//       builder: (_) => Dialog(
//         insetPadding: EdgeInsets.all(10),
//         backgroundColor: AppColors.lightTransparent,
//         child: GestureDetector(
//           onTap: () => Navigator.of(context).pop(),
//           child: SizedBox(
//             height: fullscreenHeight.h,
//             width: double.infinity,
//             child: InteractiveViewer(child: imageWidget),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   widget build(BuildContext context) {
//     return ValueListenableBuilder<File?>(
//       valueListenable: imageFileNotifier,
//       builder: (context, imageFile, _) {
//         return ValueListenableBuilder<String?>(
//           valueListenable: uploadedFileNameNotifier,
//           builder: (context, uploadedFileName, __) {
//             widget? previewImage;
//
//             if (imageFile != null) {
//               previewImage = GestureDetector(
//                 onTap: () => _showFullScreenImage(
//                   context,
//                   Image.file(imageFile, fit: BoxFit.contain),
//                 ),
//                 child: Image.file(
//                   imageFile,
//                   height: thumbnailHeight.h,
//                   width: thumbnailWidth.w,
//                   fit: BoxFit.fill,
//                 ),
//               );
//             } else if (uploadedFileName != null &&
//                 uploadedFileName.isNotEmpty) {
//               final String fullUrl =
//                   "${ApiServiceUrl.urlLauncher}Documents/${uploadedFileName}";
//               previewImage = GestureDetector(
//                 onTap: () => _showFullScreenImage(
//                   context,
//                   Image.network(fullUrl, fit: BoxFit.contain),
//                 ),
//                 child: Image.network(
//                   fullUrl,
//                   height: thumbnailHeight.h,
//                   width: thumbnailWidth.w,
//                   fit: BoxFit.fill,
//                 ),
//               );
//             } else if (imageUrl != null && imageUrl!.isNotEmpty) {
//               previewImage = GestureDetector(
//                 onTap: () => _showFullScreenImage(
//                   context,
//                   Image.network(imageUrl!, fit: BoxFit.contain),
//                 ),
//                 child: Image.network(
//                   imageUrl!,
//                   height: thumbnailHeight.h,
//                   width: thumbnailWidth.w,
//                   fit: BoxFit.fill,
//                 ),
//               );
//             } else {
//               previewImage = Container();
//             }
//
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   height: containerHeight.h,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   padding: EdgeInsets.symmetric(horizontal: 10.w),
//                   alignment: Alignment.centerLeft,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       InkWell(
//                         onTap: () => _showImagePickerModal(context),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(5),
//                             color: Colors.grey.shade200,
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 8.sp, vertical: 2.sp),
//                             child: CustomText(
//                               text: uploadButtonText,
//                               fontSize: 11.h,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 5.w),
//                       Expanded(
//                         child: CustomText(
//                           text: uploadedFileName ??
//                               (imageFile != null
//                                   ? basename(imageFile.path)
//                                   : imageUrl != null
//                                       ? basename(imageUrl!)
//                                       : ""),
//                           maxLines: 2,
//                           fontSize: 10,
//                         ),
//                       ),
//                       if (imageFile != null && imageFile.path.isNotEmpty)
//
//                         InkWell(
//                           onTap: () {
//                             imageFileNotifier.value = null;
//                             uploadedFileNameNotifier.value = null;
//                           },
//                           child: Icon(
//                             Icons.close,
//                             size: 15.h,
//                             color: AppColors.red,
//                           ),
//                         )
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 2.h),
//                 FieldLabel(text: "File should be in Jpg/png format (5 mb)"),
//                 SizedBox(height: 2.h),
//                 if (previewImage != null) ...[
//                   SizedBox(height: 5.h),
//                   previewImage,
//                 ],
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }
