import 'dart:io';

/// Interface for file operations.
abstract class FileUtils {
  Future<void> createDirectory(String path);
  Future<void> writeFile(String path, String content);
  Future<bool> exists(String path);
  Future<void> delete(String path, {bool recursive = false});
}

/// Default implementation using [Directory] and [File].
class FileUtilsImpl implements FileUtils {
  @override
  Future<void> createDirectory(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  @override
  Future<void> writeFile(String path, String content) async {
    final file = File(path);
    await file.create(recursive: true);
    await file.writeAsString(content);
  }

  @override
  Future<bool> exists(String path) {
    if (FileSystemEntity.isDirectorySync(path)) {
      return Directory(path).exists();
    }
    return File(path).exists();
  }

  @override
  Future<void> delete(String path, {bool recursive = false}) async {
    final type = FileSystemEntity.typeSync(path);
    if (type == FileSystemEntityType.directory) {
      await Directory(path).delete(recursive: recursive);
    } else if (type == FileSystemEntityType.file) {
      await File(path).delete();
    }
  }
}
