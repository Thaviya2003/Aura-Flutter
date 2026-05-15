import 'package:flutter/material.dart';

import '../models/watch_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<WatchModel> _favorites = [];

  List<WatchModel> get favorites => _favorites;

  bool isFavorite(WatchModel watch) {
    return _favorites.contains(watch);
  }

  void toggleFavorite(WatchModel watch) {
    if (_favorites.contains(watch)) {
      _favorites.remove(watch);
    } else {
      _favorites.add(watch);
    }

    notifyListeners();
  }
}
