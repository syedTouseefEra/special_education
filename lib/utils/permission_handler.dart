// import 'dart:io';
//
// import 'package:permission_handler/permission_handler.dart';
//
// Future<bool> requestPermissions() async {
//   if (Platform.isAndroid) {
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       status = await Permission.storage.request();
//       if (!status.isGranted) {
//         return false;
//       }
//     }
//   } else if (Platform.isIOS) {
//     var status = await Permission.photos.status;
//     if (!status.isGranted) {
//       status = await Permission.photos.request();
//       if (!status.isGranted) {
//         return false;
//       }
//     }
//   }
//   return true;
// }
