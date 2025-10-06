

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

String maskInput(String input) {
  if (input.contains('@')) {
    int atIndex = input.indexOf('@');
    String namePart = input.substring(0, atIndex);
    String domainPart = input.substring(atIndex);

    int nameLength = namePart.length;

    if (nameLength <= 1) {
      return input;
    }

    if (nameLength == 2) {
      return '${namePart[0]}***$domainPart';
    }

    if (nameLength == 3) {
      return '${namePart[0]}***${namePart[2]}$domainPart';
    }

    String firstChar = namePart[0];
    String lastChar = namePart[nameLength - 1];
    String masked = '*' * (nameLength - 2);

    return firstChar + masked + lastChar + domainPart;
  }


  if (input.length >= 6) {
    return '${input.substring(0, 5)}****${input.substring(input.length - 1)}';
  }

  return input;
}

int getTotalCharacterCount(String text) {
  return text.length;
}

Future<String?> downloadFile(String url, String filename) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    }
  } catch (e) {
    print('PDF download error: $e');
  }
  return null;
}

String getMediaTypeFromUrl(String url) {
  final lowerUrl = url.toLowerCase();

  if (lowerUrl.endsWith('.jpg') ||
      lowerUrl.endsWith('.jpeg') ||
      lowerUrl.endsWith('.png') ||
      lowerUrl.endsWith('.gif') ||
      lowerUrl.endsWith('.bmp') ||
      lowerUrl.endsWith('.webp')) {
    return 'image';
  } else if (lowerUrl.endsWith('.mp4') ||
      lowerUrl.endsWith('.mov') ||
      lowerUrl.endsWith('.mkv') ||
      lowerUrl.endsWith('.webm') ||
      lowerUrl.endsWith('.avi')) {
    return 'video';
  } else if (lowerUrl.endsWith('.mp3') ||
      lowerUrl.endsWith('.wav') ||
      lowerUrl.endsWith('.aac') ||
      lowerUrl.endsWith('.ogg')) {
    return 'audio';
  } else if (lowerUrl.endsWith('.pdf')) {
    return 'pdf';
  } else {
    return 'unknown';
  }
}

bool isUnsupportedVideoFormat(String url) {
  final lowerUrl = url.toLowerCase();
  if (Platform.isIOS && lowerUrl.endsWith('.webm')) {
    return true; // iOS does not support .webm
  }
  return false;
}
