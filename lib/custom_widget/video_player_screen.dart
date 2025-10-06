// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:http/http.dart' as http;
// import 'package:video_thumbnail/video_thumbnail.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as path;
//
// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;
//
//   const VideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);
//
//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   bool _isInitialized = false;
//   bool _isPlaying = false;
//   String? _thumbnailPath;
//   bool _isLoadingThumbnail = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadThumbnail();
//   }
//
//   Future<void> _loadThumbnail() async {
//     final thumbnail = await VideoThumbnailGenerator.generateThumbnail(widget.videoUrl);
//     setState(() {
//       _thumbnailPath = thumbnail;
//       _isLoadingThumbnail = false;
//     });
//   }
//
//   Future<void> _initializeAndPlayVideo() async {
//     _controller = VideoPlayerController.network(widget.videoUrl);
//     await _controller.initialize();
//     setState(() {
//       _isInitialized = true;
//       _isPlaying = true;
//     });
//     _controller.play();
//   }
//
//   @override
//   void dispose() {
//     if (_isInitialized) {
//       _controller.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Video Player')),
//       body: SizedBox(
//         height: 350,
//         child: Center(
//           child: _isLoadingThumbnail
//               ? const CircularProgressIndicator()
//               : (_isPlaying && _isInitialized)
//               ? AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             child: VideoPlayer(_controller),
//           )
//               : GestureDetector(
//             onTap: () async {
//               await _initializeAndPlayVideo();
//             },
//             child: _thumbnailPath != null
//                 ? Image.file(
//               File(_thumbnailPath!),
//               fit: BoxFit.cover,
//               width: double.infinity,
//               height: 350,
//             )
//                 : Container(
//               color: Colors.black12,
//               width: double.infinity,
//               height: 350,
//               child: const Center(child: Icon(Icons.play_arrow, size: 64)),
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: (_isInitialized && _isPlaying)
//           ? FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             if (_controller.value.isPlaying) {
//               _controller.pause();
//             } else {
//               _controller.play();
//             }
//           });
//         },
//         child: Icon(
//           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         ),
//       )
//           : null,
//     );
//   }
// }
//
// // VideoThumbnailGenerator class (unchanged)
// class VideoThumbnailGenerator {
//   static Future<String?> generateThumbnail(String videoUrl) async {
//     try {
//       final response = await http.get(Uri.parse(videoUrl));
//       if (response.statusCode != 200) throw Exception("Failed to download video");
//
//       final tempDir = await getTemporaryDirectory();
//       final videoFile = File('${tempDir.path}/${path.basename(videoUrl)}');
//       await videoFile.writeAsBytes(response.bodyBytes);
//
//       final thumbnail = await VideoThumbnail.thumbnailFile(
//         video: videoFile.path,
//         thumbnailPath: tempDir.path,
//         imageFormat: ImageFormat.JPEG,
//         maxHeight: 200,
//         quality: 75,
//       );
//
//       return thumbnail;
//     } catch (e) {
//       print("Thumbnail generation error: $e");
//       return null;
//     }
//   }
// }
