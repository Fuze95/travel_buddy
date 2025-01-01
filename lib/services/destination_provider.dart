import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/destination.dart';

class DestinationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Destination> _destinations = [];
  List<Destination> _popularDestinations = [];
  bool _isLoading = false;

  List<Destination> get destinations => _destinations;
  List<Destination> get popularDestinations => _popularDestinations;
  bool get isLoading => _isLoading;

  Future<void> fetchDestinations() async {
    _isLoading = true;
    notifyListeners();

    try {
      final QuerySnapshot snapshot = await _firestore.collection('destinations').get();
      _destinations = snapshot.docs
          .map((doc) => Destination.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      // Sort by rating to get popular destinations
      _popularDestinations = [..._destinations];
      _popularDestinations.sort((a, b) => b.rating.compareTo(a.rating));
      _popularDestinations = _popularDestinations.take(4).toList();

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      print('Error fetching destinations: $error');
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
}