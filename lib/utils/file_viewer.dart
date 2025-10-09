// import 'dart:io';
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import 'custom_function_utils.dart';
//
// class MaterialDetailView extends StatefulWidget {
//   final String title;
//   final String type;
//   final String url;
//
//   const MaterialDetailView({
//     super.key,
//     required this.title,
//     required this.type,
//     required this.url,
//   });
//
//   @override
//   State<MaterialDetailView> createState() => _MaterialDetailViewState();
// }
//
// class _MaterialDetailViewState extends State<MaterialDetailView> {
//   VideoPlayerController? _videoController;
//   ChewieController? _chewieController;
//   AudioPlayer? _audioPlayer;
//   String? _localPdfPath;
//
//   late String mediaType;
//
//   WebViewController? _webViewController; // controller for DOC/DOCX view
//
//   @override
//   void initState() {
//     super.initState();
//     mediaType = widget.type.toLowerCase();
//
//     // For Android hybrid composition setup, if needed:
//     if (Platform.isAndroid) {
//       // optional: WebView.platform = SurfaceAndroidWebView();
//       // but this depends on version and your Android setup
//     }
//
//     if (mediaType == 'video') {
//       if (isUnsupportedVideoFormat(widget.url)) return;
//
//       _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url))
//         ..initialize().then((_) {
//           _chewieController = ChewieController(
//             videoPlayerController: _videoController!,
//             autoPlay: true,
//             looping: false,
//             allowFullScreen: true,
//             fullScreenByDefault: true,
//             deviceOrientationsOnEnterFullScreen: [
//               DeviceOrientation.landscapeLeft,
//               DeviceOrientation.landscapeRight,
//             ],
//
//             deviceOrientationsAfterFullScreen: [
//               DeviceOrientation.portraitUp,
//               DeviceOrientation.portraitDown,
//             ],
//           );
//           setState(() {});
//         }).catchError((e) {
//           debugPrint("Error initializing video: $e");
//         });
//     } else if (mediaType == 'audio') {
//       _audioPlayer = AudioPlayer()..play(UrlSource(widget.url));
//     } else if (mediaType == 'pdf') {
//       downloadFile(widget.url, 'temp.pdf').then((path) {
//         if (mounted) {
//           setState(() {
//             _localPdfPath = path;
//           });
//         }
//       });
//     } else if (mediaType == 'doc' || mediaType == 'docx') {
//       // Setup WebViewController
//       _webViewController = WebViewController()
//         ..setJavaScriptMode(JavaScriptMode.unrestricted)
//         ..setNavigationDelegate(
//           NavigationDelegate(
//             onPageStarted: (url) {
//               // You can set state to show loading, etc.
//             },
//             onPageFinished: (url) {
//               // hide loading indicator
//             },
//             onWebResourceError: (error) {
//               debugPrint("WebView error: ${error.description}");
//             },
//           ),
//         )
//         ..loadRequest(
//           Uri.parse(
//             'https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(widget.url)}',
//           ),
//         );
//     }
//   }
//
//   @override
//   void dispose() {
//     _videoController?.dispose();
//     _chewieController?.dispose();
//     _audioPlayer?.dispose();
//     super.dispose();
//   }
//
//   widget _buildDocViewer() {
//     if (_webViewController == null) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     return WebViewWidget(controller: _webViewController!);
//   }
//
//   widget _buildContent() {
//     switch (mediaType) {
//       case 'image':
//         return InteractiveViewer(
//           panEnabled: true,
//           minScale: 1.0,
//           maxScale: 4.0,
//           child: Image.network(
//             widget.url,
//             fit: BoxFit.contain,
//             loadingBuilder: (context, child, loadingProgress) {
//               if (loadingProgress == null) return child;
//               return const Center(child: CircularProgressIndicator());
//             },
//             errorBuilder: (context, error, stackTrace) {
//               return const Center(child: Text('Failed to load image'));
//             },
//           ),
//         );
//
//       case 'pdf':
//         if (_localPdfPath == null) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         return PDFView(
//           filePath: _localPdfPath,
//           enableSwipe: true,
//           swipeHorizontal: false,
//           autoSpacing: true,
//           pageFling: true,
//         );
//
//       case 'video':
//         if (isUnsupportedVideoFormat(widget.url)) {
//           return Center(
//             child: CustomText(
//               text: 'This video format is not supported on your device.',
//               fontSize: 15.sp,
//               fontFamily: 'Inter',
//               fontWeight: FontWeight.w400,
//               color: AppColors.red,
//               textCase: TextCase.sentence,
//             ),
//           );
//         }
//
//         if (_chewieController != null &&
//             _chewieController!.videoPlayerController.value.isInitialized) {
//           return Chewie(controller: _chewieController!);
//         } else {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//       case 'audio':
//         return Center(
//           child:
//               Icon(Icons.audiotrack, size: 100.h, color: AppColors.themeColor),
//         );
//
//       case 'doc':
//       case 'docx':
//         return _buildDocViewer();
//
//       default:
//         return const Center(child: Text("Unsupported media type"));
//     }
//   }
//
//   @override
//   widget build(BuildContext context) {
//     return Container(
//       color: AppColors.themeColor,
//       child: SafeArea(
//         child: Scaffold(
//           body: Center(
//             child: Column(
//               children: [
//                 CustomHeaderView(
//                     courseName: widget.title, moduleName: widget.type),
//                 Expanded(child: _buildContent()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
