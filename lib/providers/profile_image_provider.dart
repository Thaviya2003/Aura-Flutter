import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

Future<File> saveImagePermanently(String imagePath) async {
  final directory = await getApplicationDocumentsDirectory();

  final name = basename(imagePath);

  final image = File(imagePath);

  final savedImage = await image.copy('${directory.path}/$name');

  return savedImage;
}

class ProfileImageProvider extends ChangeNotifier {
  File? _image;

  String? _errorMessage;

  bool _isLoading = false;

  String? get errorMessage => _errorMessage;

  bool get isLoading => _isLoading;

  File? get image => _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromGallery() async {
    _isLoading = true;

    _errorMessage = null;

    notifyListeners();

    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        _errorMessage = 'No image selected';
      } else {
        await deleteOldImage();

        final savedImage = await saveImagePermanently(pickedFile.path);

        _image = savedImage;

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('profile_image', savedImage.path);
      }
    } catch (e) {
      _errorMessage = 'Failed to access gallery';
    }

    _isLoading = false;

    notifyListeners();
  }

  Future<void> pickImageFromCamera() async {
    _isLoading = true;

    _errorMessage = null;

    notifyListeners();

    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile == null) {
        _errorMessage = 'Camera operation cancelled';
      } else {
        await deleteOldImage();

        final savedImage = await saveImagePermanently(pickedFile.path);

        _image = savedImage;

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('profile_image', savedImage.path);
      }
    } catch (e) {
      _errorMessage = 'Failed to access camera';
    }

    _isLoading = false;

    notifyListeners();
  }

  Future<void> loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();

    final imagePath = prefs.getString('profile_image');

    if (imagePath != null) {
      _image = File(imagePath);

      notifyListeners();
    }
  }

  Future<void> deleteOldImage() async {
    final prefs = await SharedPreferences.getInstance();

    final oldImagePath = prefs.getString('profile_image');

    if (oldImagePath != null) {
      final oldImage = File(oldImagePath);

      if (await oldImage.exists()) {
        await oldImage.delete();
      }
    }
  }

  Future<void> removeProfileImage() async {
    final prefs = await SharedPreferences.getInstance();

    final imagePath = prefs.getString('profile_image');

    if (imagePath != null) {
      final imageFile = File(imagePath);

      if (await imageFile.exists()) {
        await imageFile.delete();
      }
    }

    await prefs.remove('profile_image');

    _image = null;

    notifyListeners();
  }
}
