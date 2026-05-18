import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool isOnline = true;

  ConnectivityProvider() {
    monitorInternet();
  }

  void monitorInternet() {
    InternetConnection().onStatusChange.listen((status) {
      isOnline = status == InternetStatus.connected;

      notifyListeners();
    });
  }
}
