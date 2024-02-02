
import 'dart:io';
import 'dart:typed_data';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  static Future<String> saveAndOpenImage(Uint8List data) async {
    // save image to file
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final File file = File('$dir/$fileName.png');
    await file.writeAsBytes(data);
    OpenFile.open(file.path);
    return file.path;
  }
}
