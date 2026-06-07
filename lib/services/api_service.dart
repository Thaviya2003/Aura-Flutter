import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/api_watch_model.dart';

class ApiService {
  Future<List<ApiWatchModel>> fetchWatches({required bool isOnline}) async {
    try {
      if (isOnline) {
        final response = await http.get(
          Uri.parse('https://thaviya2003.github.io/watchesjson/watches.json'),
        );

        if (response.statusCode == 200) {
          final List data = jsonDecode(response.body);

          return data.map((json) => ApiWatchModel.fromJson(json)).toList();
        }
      }
    } catch (_) {}

    final localJson = await rootBundle.loadString('assets/data/watches.json');

    final List localData = jsonDecode(localJson);

    return localData.map((json) => ApiWatchModel.fromJson(json)).toList();
  }
}
