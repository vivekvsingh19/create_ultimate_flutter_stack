import 'dart:io';

class FileUtils {
  static Future<void> createDirectory(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  static Future<void> writeFile(String path, String content) async {
    final file = File(path);
    await file.create(recursive: true);
    await file.writeAsString(content);
  }
}
