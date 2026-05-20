import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompressor {
  static const int _maxBytes = 180 * 1024; // 180 KB — stay safely under the 200 KB server limit

  /// Compresses [file] to under 180 KB by capping resolution then reducing quality.
  /// Returns the original file if it's already small enough.
  static Future<File> compress(File file) async {
    if (await file.length() <= _maxBytes) return file;

    final targetPath =
        '${Directory.systemTemp.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg';

    // Resolution caps (minWidth/minHeight = max output dimensions in this package)
    const maxDimension = 1024;

    int quality = 80;
    Uint8List? out;

    while (quality >= 20) {
      out = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: maxDimension,
        minHeight: maxDimension,
        quality: quality,
        format: CompressFormat.jpeg,
      );
      if (out != null && out.lengthInBytes <= _maxBytes) break;
      quality -= 10;
    }

    // If still over limit, try with a smaller resolution
    if (out == null || out.lengthInBytes > _maxBytes) {
      out = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minWidth: 600,
        minHeight: 600,
        quality: 60,
        format: CompressFormat.jpeg,
      );
    }

    if (out == null) return file;

    final result = File(targetPath);
    await result.writeAsBytes(out);
    return result;
  }
}
