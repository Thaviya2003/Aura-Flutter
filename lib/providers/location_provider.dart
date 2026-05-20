import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  Position? _position;

  Position? get position => _position;

  Future<void> loadLocation() async {
    _position = await _locationService.getCurrentLocation();
    notifyListeners();
  }
}
