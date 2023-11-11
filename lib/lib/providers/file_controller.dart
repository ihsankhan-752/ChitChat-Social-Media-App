import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class FileController extends ChangeNotifier {
  File? _pickedFile;

  File? get pickedFile => _pickedFile;

  Future selectFile() async {
    final result = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 20),
    );
    if (result == null) return;

    _pickedFile = File(result.path);
    notifyListeners();
  }

  removeUploadVideoUrl() {
    _pickedFile = null;
    notifyListeners();
  }
}
