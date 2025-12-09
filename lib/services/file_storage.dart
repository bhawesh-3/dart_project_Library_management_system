import 'dart:convert';
import 'dart:io';

class FileStorage {
  /// Read JSON data from [path]. If file does not exist, throws.
  static Map<String, dynamic> readJson(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      throw FileSystemException('File not found', path);
    }
    final content = file.readAsStringSync();
    if (content.trim().isEmpty) return {};
    return jsonDecode(content) as Map<String, dynamic>;
  }

  /// Write JSON map to [path].
  static void writeJson(String path, Map<String, dynamic> data) {
    final file = File(path);
    // Ensure containing directory exists
    final dir = file.parent;
    if (!dir.existsSync()) dir.createSync(recursive: true);
    file.writeAsStringSync(jsonEncode(data), flush: true);
  }

  /// Ensure file exists, and if not create it with [initialData].
  static void ensureFile(String path, Map<String, dynamic> initialData) {
    final file = File(path);
    if (!file.existsSync()) {
      writeJson(path, initialData);
    }
  }
}
