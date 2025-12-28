import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickAndSaveImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return null;

    final directory = await getApplicationDocumentsDirectory();
    final fileName = p.basename(pickedFile.path);
    final savedImage = File('${directory.path}/$fileName');

    return File(pickedFile.path).copy(savedImage.path);
  }
}
