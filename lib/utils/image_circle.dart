


import 'package:flutter/Material.dart';
import 'package:special_education/api_service/api_service_url.dart';
import 'package:special_education/constant/assets.dart';

Widget buildCircleAvatar({
  required BuildContext context,
  required String? imageName,
  required String folder,
  double radius = 20,
  String defaultAsset = ImgAssets.user,
}) {
  ImageProvider imageProvider;
  String? imageUrl;

  if (imageName == null || imageName.isEmpty) {
    imageProvider = AssetImage(defaultAsset);
  } else {
    imageUrl = '${ApiServiceUrl.urlLauncher}$folder/$imageName';
    imageProvider = NetworkImage(imageUrl);
  }

  return GestureDetector(
    onTap: () {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => FullScreenImagePage(
      //       imageUrl: imageUrl,
      //       assetPath: imageName == null || imageName.isEmpty ? defaultAsset : null,
      //     ),
      //   ),
      // );
    },
    child: Hero(
      tag: "profileImage",
      child: CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
      ),
    ),
  );
}


