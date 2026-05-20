import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileImageProvider extends ChangeNotifier {
  File? _image;

  File? get image => _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('profile_image', pickedFile.path);

      notifyListeners();
    }
  }

  Future<void> pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('profile_image', pickedFile.path);

      notifyListeners();
    }
  }

  Future<void> loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();

    final imagePath = prefs.getString('profile_image');

    if (imagePath != null) {
      _image = File(imagePath);

      notifyListeners();
    }
  }
}
