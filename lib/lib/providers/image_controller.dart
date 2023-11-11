import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends ChangeNotifier {
  File? _selectedImage;
  List<XFile>? _imageFileList = [];
  File? get selectedImage => _selectedImage;

  List<XFile>? get imageFileList => _imageFileList;

  uploadImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    _selectedImage = File(pickedFile!.path);
    notifyListeners();
  }

  deleteUploadPhoto() {
    _selectedImage = null;
    notifyListeners();
  }

  uploadPostImages() async {
    final pickedFile = await ImagePicker().pickMultiImage();

    _imageFileList = pickedFile;
    notifyListeners();
  }

  clearPostImages() {
    _imageFileList!.clear();
    notifyListeners();
  }
}
