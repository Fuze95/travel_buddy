import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/destination.dart';

class DestinationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SharedPreferences _prefs;
  List<Destination> _destinations = [];
  List<Destination> _popularDestinations = [];
  Set<String> _favoriteIds = {};
  bool _isLoading = false;
  String _error = '';

  DestinationProvider(this._prefs) {
    _loadFavoriteIds();
  }

  List<Destination> get destinations => _destinations;
  List<Destination> get popularDestinations => _popularDestinations;
  List<Destination> get favorites => _destinations.where((d) => isFavorite(d.id)).toList();
  bool get isLoading => _isLoading;
  String get error => _error;

  void _loadFavoriteIds() {
    final favoritesJson = _prefs.getStringList('favorites') ?? [];
    _favoriteIds = favoritesJson.toSet();
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  Future<void> toggleFavorite(String destinationId) async {
    if (_favoriteIds.contains(destinationId)) {
      _favoriteIds.remove(destinationId);
    } else {
      _favoriteIds.add(destinationId);
    }

    await _prefs.setStringList('favorites', _favoriteIds.toList());

    // Update the destination objects with new favorite status
    _destinations = _destinations.map((destination) {
      if (destination.id == destinationId) {
        return destination.copyWith(
            isFavorite: _favoriteIds.contains(destinationId)
        );
      }
      return destination;
    }).toList();

    // Also update popular destinations
    _popularDestinations = _popularDestinations.map((destination) {
      if (destination.id == destinationId) {
        return destination.copyWith(
            isFavorite: _favoriteIds.contains(destinationId)
        );
      }
      return destination;
    }).toList();

    notifyListeners();
  }

  Future<void> fetchDestinations() async {
    _isLoading = true;
    notifyListeners();

    try {
      final QuerySnapshot snapshot = await _firestore.collection('destinations').get();
      _destinations = snapshot.docs
          .map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Destination.fromJson(data).copyWith(
            isFavorite: _favoriteIds.contains(data['id'])
        );
      })
          .toList();

      // Sort by rating to get popular destinations
      _popularDestinations = [..._destinations];
      _popularDestinations.sort((a, b) => b.rating.compareTo(a.rating));
      _popularDestinations = _popularDestinations.take(4).toList();

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _error = 'Error fetching destinations: $error';
      print(_error);
      notifyListeners();
    }
  }

  List<Destination> getDestinationsByCategory(String category) {
    if (category == 'All') {
      return _destinations;
    }
    // Convert category to lowercase for case-insensitive comparison
    final searchCategory = category.toLowerCase().replaceAll(' & ', ' ').replaceAll(' ', '-');
    return _destinations.where((dest) =>
        dest.category.map((c) => c.toLowerCase()).contains(searchCategory)
    ).toList();
  }

  Future<List<Destination>> searchDestinations(String searchTerm) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Convert search term to lowercase for case-insensitive search
      final searchLower = searchTerm.toLowerCase();

      // Search through existing destinations first if available
      if (_destinations.isNotEmpty) {
        final results = _destinations.where((destination) {
          final name = destination.name.toLowerCase();
          final description = destination.description.toLowerCase();
          final activities = destination.activities
              .map((e) => e.toLowerCase())
              .toList();
          final categories = destination.category
              .map((e) => e.toLowerCase())
              .toList();

          return name.contains(searchLower) ||
              description.contains(searchLower) ||
              activities.any((activity) => activity.contains(searchLower)) ||
              categories.any((category) => category.contains(searchLower));
        }).toList();

        _isLoading = false;
        notifyListeners();
        return results;
      }

      // If no destinations are loaded, fetch from Firebase
      final QuerySnapshot snapshot = await _firestore
          .collection('destinations')
          .get();

      final results = snapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final name = (data['name'] as String).toLowerCase();
        final description = (data['description'] as String).toLowerCase();
        final activities = List<String>.from(data['activities'] ?? [])
            .map((e) => e.toLowerCase())
            .toList();
        final categories = List<String>.from(data['category'] ?? [])
            .map((e) => e.toLowerCase())
            .toList();

        return name.contains(searchLower) ||
            description.contains(searchLower) ||
            activities.any((activity) => activity.contains(searchLower)) ||
            categories.any((category) => category.contains(searchLower));
      }).map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Destination.fromJson(data).copyWith(
            isFavorite: _favoriteIds.contains(data['id'])
        );
      }).toList();

      _isLoading = false;
      _error = '';
      notifyListeners();
      return results;
    } catch (e) {
      _error = 'Error searching destinations: $e';
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}