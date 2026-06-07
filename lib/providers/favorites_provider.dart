import 'package:flutter/material.dart';

import '../models/api_watch_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<ApiWatchModel> _favorites = [];

  List<ApiWatchModel> get favorites => _favorites;

  bool isFavorite(ApiWatchModel watch) {
    return _favorites.any((item) => item.id == watch.id);
  }

  void toggleFavorite(ApiWatchModel watch) {
    if (isFavorite(watch)) {
      _favorites.removeWhere((item) => item.id == watch.id);
    } else {
      _favorites.add(watch);
    }

    notifyListeners();
  }
}
