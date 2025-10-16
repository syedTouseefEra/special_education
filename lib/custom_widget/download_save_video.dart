import 'dart:async';
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:special_education/components/alert_view.dart';

import 'package:permission_handler/permission_handler.dart';

Future<void> downloadAndShareVideo(String url, String fileName) async {
  final status = await Permission.storage.request();

  if (!status.isGranted) {
    AlertView().alertToast("Storage permission is required");
    return;
  }

  final baseStorage = await getApplicationDocumentsDirectory();

  final taskId = await FlutterDownloader.enqueue(
    url: url,
    savedDir: baseStorage.path,
    fileName: fileName,
    showNotification: true,
    openFileFromNotification: false,
  );

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    final tasks = await FlutterDownloader.loadTasksWithRawQuery(
      query: "SELECT * FROM task WHERE task_id='$taskId'",
    );

    if (tasks != null && tasks.isNotEmpty) {
      final task = tasks.first;
      if (task.status == DownloadTaskStatus.complete) {
        timer.cancel();
        final filePath = '${baseStorage.path}/$fileName';
        if (await File(filePath).exists()) {
          await SharePlus.instance.share(
            ShareParams(
              files: [XFile(filePath)],
              text: 'Here is your downloaded video',
            ),
          );
        } else {
          AlertView().alertToast("Downloaded file not found");
        }
      } else if (task.status == DownloadTaskStatus.failed) {
        timer.cancel();
        AlertView().alertToast("Download failed");
      }
    }
  });
}
