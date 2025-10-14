
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class VideoThumbnailGenerator {
  static Future<String?> generateThumbnail(String videoUrl) async {
    try {
      final response = await http.get(Uri.parse(videoUrl));
      if (response.statusCode != 200) throw Exception("Failed to download video");

      final tempDir = await getTemporaryDirectory();
      final videoFile = File('${tempDir.path}/${path.basename(videoUrl)}');
      await videoFile.writeAsBytes(response.bodyBytes);

      final thumbnail = await VideoThumbnail.thumbnailFile(
        video: videoFile.path,
        thumbnailPath: tempDir.path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 200,
        quality: 75,
      );

      return thumbnail;
    } catch (e) {
      print("Thumbnail generation error: $e");
      return null;
    }
  }
}
