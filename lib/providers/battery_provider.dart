import 'package:flutter/material.dart';

import '../services/battery_service.dart';

class BatteryProvider extends ChangeNotifier {
  final BatteryService _batteryService = BatteryService();

  int _batteryLevel = 0;

  int get batteryLevel => _batteryLevel;

  Future<void> loadBatteryLevel() async {
    _batteryLevel = await _batteryService.getBatteryLevel();
    notifyListeners();
  }
}
