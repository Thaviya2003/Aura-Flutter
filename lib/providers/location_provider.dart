import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  Position? _position;

  bool _isLoading = false;

  String? _errorMessage;

  Position? get position => _position;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> loadLocation() async {
    _isLoading = true;

    _errorMessage = null;

    notifyListeners();

    try {
      _position = await _locationService.getCurrentLocation();

      if (_position == null) {
        _errorMessage = 'Location unavailable or permission denied';
      }
    } catch (e) {
      _errorMessage = 'Failed to get location';
    }

    _isLoading = false;

    notifyListeners();
  }
}
