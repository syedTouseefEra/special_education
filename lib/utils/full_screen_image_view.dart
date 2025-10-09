//
//
// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view.dart';
//
// class FullScreenImagePage extends StatelessWidget {
//   final String? imageUrl;
//   final String? assetPath;
//
//   const FullScreenImagePage({
//     super.key,
//     this.imageUrl,
//     this.assetPath,
//   });
//
//   @override
//   widget build(BuildContext context) {
//     ImageProvider imageProvider;
//
//     if (imageUrl != null) {
//       imageProvider = NetworkImage(imageUrl!);
//     } else {
//       imageProvider = AssetImage(assetPath!);
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         iconTheme: const IconThemeData(color: Colors.white),
//         elevation: 0,
//       ),
//       body: Center(
//         child: PhotoView(
//           imageProvider: imageProvider,
//           backgroundDecoration: const BoxDecoration(
//             color: Colors.black,
//           ),
//           minScale: PhotoViewComputedScale.contained,
//           maxScale: PhotoViewComputedScale.covered * 2.5,
//           heroAttributes: const PhotoViewHeroAttributes(tag: "profileImage"),
//         ),
//       ),
//     );
//   }
// }
//
