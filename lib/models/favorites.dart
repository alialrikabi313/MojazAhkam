import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider with ChangeNotifier {
  List<String> _favoriteIssues = [];

  List<String> get favoriteIssues {
    return [..._favoriteIssues];
  }

  void toggleFavorite(String issue) async {
    final prefs = await SharedPreferences.getInstance();
    if (_favoriteIssues.contains(issue)) {
      _favoriteIssues.remove(issue);
    } else {
      _favoriteIssues.add(issue);
    }
    notifyListeners();
    prefs.setStringList('favorites', _favoriteIssues);
  }

  bool isFavorite(String issue) {
    return _favoriteIssues.contains(issue);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteIssues = prefs.getStringList('favorites') ?? [];
    notifyListeners();
  }
}
