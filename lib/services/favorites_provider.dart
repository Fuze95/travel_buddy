import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/destination.dart';

class FavoritesProvider with ChangeNotifier {
  final SharedPreferences prefs;
  Set<String> _favoriteIds = {};
  List<Destination> _favorites = [];

  FavoritesProvider(this.prefs) {
    _loadFavorites();
  }

  List<Destination> get favorites => _favorites;
  bool isFavorite(String id) => _favoriteIds.contains(id);

  Future<void> _loadFavorites() async {
    final favoritesJson = prefs.getStringList('favorites') ?? [];
    _favoriteIds = favoritesJson.toSet();
    notifyListeners();
  }

  Future<void> toggleFavorite(Destination destination) async {
    if (_favoriteIds.contains(destination.id)) {
      _favoriteIds.remove(destination.id);
      _favorites.removeWhere((d) => d.id == destination.id);
    } else {
      _favoriteIds.add(destination.id);
      _favorites.add(destination.copyWith(isFavorite: true));
    }

    await prefs.setStringList('favorites', _favoriteIds.toList());
    notifyListeners();
  }
}