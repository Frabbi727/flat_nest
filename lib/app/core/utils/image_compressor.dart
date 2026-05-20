import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompressor {
  static const int _maxBytes = 200 * 1024; // 200 KB

  /// Compresses [file] to under 200 KB by reducing JPEG quality.
  /// Returns the original file if it's already small enough.
  static Future<File> compress(File file) async {
    if (await file.length() <= _maxBytes) return file;

    final targetPath =
        '${Directory.systemTemp.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';

    int quality = 85;
    Uint8List? out;

    while (quality >= 20) {
      out = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        quality: quality,
        format: CompressFormat.jpeg,
      );
      if (out != null && out.lengthInBytes <= _maxBytes) break;
      quality -= 15;
    }

    if (out == null) return file;

    final result = File(targetPath);
    await result.writeAsBytes(out);
    return result;
  }
}
