import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/api_watch_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<ApiWatchModel> _favorites = [];

  List<ApiWatchModel> get favorites => _favorites;

  bool isFavorite(ApiWatchModel watch) {
    return _favorites.any((item) => item.id == watch.id);
  }

  Future<void> loadFavorites(List<ApiWatchModel> allWatches) async {
    final prefs = await SharedPreferences.getInstance();

    final savedIds = prefs.getStringList('favorite_ids') ?? [];

    _favorites.clear();

    for (final watch in allWatches) {
      if (savedIds.contains(watch.id.toString())) {
        _favorites.add(watch);
      }
    }

    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final ids = _favorites.map((e) => e.id.toString()).toList();

    await prefs.setStringList('favorite_ids', ids);
  }

  Future<void> toggleFavorite(ApiWatchModel watch) async {
    if (isFavorite(watch)) {
      _favorites.removeWhere((item) => item.id == watch.id);
    } else {
      _favorites.add(watch);
    }

    await _saveFavorites();

    notifyListeners();
  }
}
