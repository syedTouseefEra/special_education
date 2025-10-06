import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

String getFileExtension(String fileUrl) {
  if (fileUrl.isEmpty) {
    debugPrint('No file URL provided.');
    return '';
  }

  final fileExtension = path.extension(fileUrl).replaceFirst('.', '').toLowerCase();
  return fileExtension;
}

String getMediaTypeFromUrl(String url) {
  final ext = getFileExtension(url);

  switch (ext) {
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
      return 'image';
    case 'mp4':
    case 'mov':
    case 'avi':
      return 'video';
    case 'mp3':
    case 'wav':
    case 'aac':
      return 'audio';
    case 'pdf':
      return 'pdf';
    default:
      return 'unsupported';
  }
}
