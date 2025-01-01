import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload destinations data from JSON
  Future<void> uploadDestinations() async {
    try {
      String jsonString = '''
      {
        "colombo-001": {
          "id": "colombo-001",
          "name": "Colombo",
          "description": "Sri Lanka's bustling commercial capital and largest city, offering a mix of modern and colonial architecture, shopping, and diverse dining options.",
          "imageUrl": "[storage_url]/colombo_main.jpg",
          "latitude": 6.9271,
          "longitude": 79.8612,
          "rating": 4.2,
          "activities": [
            "Shopping at Pettah Market",
            "Visit Gangaramaya Temple",
            "Galle Face Green promenade",
            "National Museum tour",
            "Colombo Port City visit"
          ],
          "category": ["urban", "cultural", "shopping"],
          "highlights": [
            "Galle Face Green",
            "Gangaramaya Temple",
            "National Museum",
            "Pettah Market",
            "Independence Square"
          ],
          "bestTimeToVisit": "January to March",
          "localTips": [
            "Use tuk-tuks for short distances but agree on price beforehand",
            "Visit Galle Face Green during sunset",
            "Try local street food at Pettah Market",
            "Use ride-hailing apps for reliable transportation"
          ],
          "transportationOptions": [
            "Taxi from Airport (1 hour)",
            "Public buses",
            "Tuk-tuks for short distances",
            "Train from major cities"
          ],
          "weatherInfo": {
            "summerTemp": "27-32°C",
            "winterTemp": "24-28°C",
            "rainySeasons": ["May", "September", "October"]
          }
        },
        "kandy-001": {
          "id": "kandy-001",
          "name": "Kandy",
          "description": "The cultural capital of Sri Lanka, home to the Temple of the Sacred Tooth Relic and surrounded by beautiful hills and tea plantations.",
          "imageUrl": "[storage_url]/kandy_main.jpg",
          "latitude": 7.2906,
          "longitude": 80.6337,
          "rating": 4.6,
          "activities": [
            "Visit Temple of the Sacred Tooth",
            "Royal Botanical Gardens tour",
            "Kandy Lake walk",
            "Cultural dance shows",
            "Tea factory visits"
          ],
          "category": ["cultural", "religious", "nature"],
          "highlights": [
            "Temple of the Sacred Tooth",
            "Royal Botanical Gardens",
            "Kandy Lake",
            "Ceylon Tea Museum",
            "Udawattakele Forest Reserve"
          ],
          "bestTimeToVisit": "December to April",
          "localTips": [
            "Visit Temple of Sacred Tooth during puja times",
            "Book cultural dance shows in advance",
            "Wear modest clothing for temple visits",
            "Try local Kandyan sweets"
          ],
          "transportationOptions": [
            "Train from Colombo (3-4 hours)",
            "Private taxi",
            "Public bus service",
            "Organized tours"
          ],
          "weatherInfo": {
            "summerTemp": "24-28°C",
            "winterTemp": "20-24°C",
            "rainySeasons": ["October", "November"]
          }
        },
        "sigiriya-001": {
          "id": "sigiriya-001",
          "name": "Sigiriya",
          "description": "Ancient palace and fortress complex recognized as a UNESCO World Heritage site, famous for its ancient frescoes and lion-shaped gateway.",
          "imageUrl": "[storage_url]/sigiriya_main.jpg",
          "latitude": 7.9570,
          "longitude": 80.7603,
          "rating": 4.8,
          "activities": [
            "Rock climbing",
            "Archaeological tours",
            "Photography",
            "Garden walks",
            "Museum visits"
          ],
          "category": ["historical", "cultural", "nature"],
          "highlights": [
            "Lion Rock Fortress",
            "Ancient Water Gardens",
            "Mirror Wall",
            "Sigiriya Museum",
            "Pidurangala Rock"
          ],
          "bestTimeToVisit": "December to April",
          "localTips": [
            "Visit early morning to avoid crowds and heat",
            "Carry plenty of water",
            "Wear comfortable walking shoes",
            "Allow 3-4 hours for complete exploration"
          ],
          "transportationOptions": [
            "Private taxi from Colombo (4 hours)",
            "Public bus from Dambulla",
            "Organized tours from major cities"
          ],
          "weatherInfo": {
            "summerTemp": "30-34°C",
            "winterTemp": "24-28°C",
            "rainySeasons": ["October", "November"]
          }
        },
        "ella-001": {
          "id": "ella-001",
          "name": "Ella",
          "description": "A picturesque mountain village famous for its scenic railway journeys, hiking trails, and tea plantations.",
          "imageUrl": "[storage_url]/ella_main.jpg",
          "latitude": 6.8667,
          "longitude": 81.0466,
          "rating": 4.7,
          "activities": [
            "Hiking Little Adam's Peak",
            "Nine Arch Bridge visit",
            "Tea plantation tours",
            "Train journey through hills",
            "Ravana Falls visit"
          ],
          "category": ["nature", "adventure", "scenic"],
          "highlights": [
            "Nine Arch Bridge",
            "Little Adam's Peak",
            "Ella Rock",
            "Tea Factories",
            "Ravana Falls"
          ],
          "bestTimeToVisit": "January to March",
          "localTips": [
            "Book train tickets in advance",
            "Visit Nine Arch Bridge early morning",
            "Try local cooking classes",
            "Bring warm clothes for evenings"
          ],
          "transportationOptions": [
            "Scenic train from Kandy",
            "Private taxi",
            "Public bus",
            "Organized tours"
          ],
          "weatherInfo": {
            "summerTemp": "22-28°C",
            "winterTemp": "18-24°C",
            "rainySeasons": ["October", "November"]
          }
        },
        "galle-001": {
          "id": "galle-001",
          "name": "Galle",
          "description": "Historic coastal city known for its well-preserved Dutch colonial fort, boutique shops, and beautiful beaches.",
          "imageUrl": "[storage_url]/galle_main.jpg",
          "latitude": 6.0535,
          "longitude": 80.2210,
          "rating": 4.5,
          "activities": [
            "Walking tour of Galle Fort",
            "Sunset at Flag Rock",
            "Maritime Museum visit",
            "Boutique shopping",
            "Beach activities"
          ],
          "category": ["historical", "coastal", "cultural"],
          "highlights": [
            "Galle Fort",
            "Lighthouse",
            "Dutch Reformed Church",
            "Maritime Museum",
            "Japanese Peace Pagoda"
          ],
          "bestTimeToVisit": "December to April",
          "localTips": [
            "Visit Fort early morning or late afternoon",
            "Try local seafood restaurants",
            "Book boutique hotels within Fort",
            "Take walking tours with local guides"
          ],
          "transportationOptions": [
            "Train from Colombo (2-3 hours)",
            "Coastal bus service",
            "Private taxi",
            "Organized tours"
          ],
          "weatherInfo": {
            "summerTemp": "26-31°C",
            "winterTemp": "25-29°C",
            "rainySeasons": ["May", "October"]
          }
        },
        "nuwara-eliya-001": {
          "id": "nuwara-eliya-001",
          "name": "Nuwara Eliya",
          "description": "Known as 'Little England', this hill station features colonial architecture, tea plantations, and cool climate gardens.",
          "imageUrl": "[storage_url]/nuwara_eliya_main.jpg",
          "latitude": 6.9497,
          "longitude": 80.7891,
          "rating": 4.4,
          "activities": [
            "Tea plantation visits",
            "Victoria Park walks",
            "Boat rides on Gregory Lake",
            "Golf at historic course",
            "Horton Plains hiking"
          ],
          "category": ["hill-country", "nature", "colonial"],
          "highlights": [
            "Victoria Park",
            "Gregory Lake",
            "Pedro Tea Estate",
            "Horton Plains",
            "Single Tree Hill"
          ],
          "bestTimeToVisit": "March to May",
          "localTips": [
            "Pack warm clothing",
            "Visit tea factories in morning",
            "Book hotels in advance during season",
            "Try local strawberry farms"
          ],
          "transportationOptions": [
            "Train from Kandy",
            "Private taxi",
            "Public bus service",
            "Organized tours"
          ],
          "weatherInfo": {
            "summerTemp": "18-22°C",
            "winterTemp": "14-18°C",
            "rainySeasons": ["October", "November"]
          }
        },
        "yala-001": {
          "id": "yala-001",
          "name": "Yala National Park",
          "description": "Sri Lanka's most popular wildlife park, famous for leopards, elephants, and diverse bird species.",
          "imageUrl": "[storage_url]/yala_main.jpg",
          "latitude": 6.3716,
          "longitude": 81.5161,
          "rating": 4.6,
          "activities": [
            "Safari tours",
            "Bird watching",
            "Photography sessions",
            "Camping experiences",
            "Beach visits"
          ],
          "category": ["wildlife", "nature", "adventure"],
          "highlights": [
            "Leopard sightings",
            "Elephant herds",
            "Ancient ruins",
            "Coastal areas",
            "Bird watching spots"
          ],
          "bestTimeToVisit": "February to July",
          "localTips": [
            "Book safari in advance",
            "Start early morning for best sightings",
            "Carry binoculars",
            "Choose reputable safari operators"
          ],
          "transportationOptions": [
            "Private taxi from Colombo",
            "Public bus to Tissamaharama",
            "Organized safari tours",
            "Local transport to park entrance"
          ],
          "weatherInfo": {
            "summerTemp": "26-30°C",
            "winterTemp": "24-28°C",
            "rainySeasons": ["October", "November", "December"]
          }
        },
        "bentota-001": {
          "id": "bentota-001",
          "name": "Bentota",
          "description": "Popular beach resort town known for water sports, ayurvedic spas, and luxury hotels.",
          "imageUrl": "[storage_url]/bentota_main.jpg",
          "latitude": 6.4213,
          "longitude": 79.9947,
          "rating": 4.3,
          "activities": [
            "Water sports",
            "River safari",
            "Ayurvedic treatments",
            "Beach relaxation",
            "Turtle hatchery visits"
          ],
          "category": ["beach", "water-sports", "luxury"],
          "highlights": [
            "Bentota Beach",
            "Brief Garden",
            "Bentota River",
            "Water Sports Center",
            "Turtle Hatchery"
          ],
          "bestTimeToVisit": "December to April",
          "localTips": [
            "Book water sports early morning",
            "Visit Brief Garden with guide",
            "Pre-book spa treatments",
            "Try local seafood restaurants"
          ],
          "transportationOptions": [
            "Train from Colombo",
            "Private taxi",
            "Public bus",
            "Hotel transfers"
          ],
          "weatherInfo": {
            "summerTemp": "27-32°C",
            "winterTemp": "25-30°C",
            "rainySeasons": ["May", "October"]
          }
        },
        "mirissa-001": {
          "id": "mirissa-001",
          "name": "Mirissa",
          "description": "Laid-back beach town famous for whale watching, surfing, and beautiful sunsets.",
          "imageUrl": "[storage_url]/mirissa_main.jpg",
          "latitude": 5.9483,
          "longitude": 80.4716,
          "rating": 4.5,
          "activities": [
            "Whale watching",
            "Surfing",
            "Sunset viewing",
            "Snorkeling",
            "Beach hopping"
          ],
          "category": ["beach", "water-sports", "wildlife"],
          "highlights": [
            "Whale Watching Point",
            "Secret Beach",
            "Parrot Rock",
            "Coconut Tree Hill",
            "Surf Points"
          ],
          "bestTimeToVisit": "November to April",
          "localTips": [
            "Book whale watching tours early",
            "Visit Coconut Hill during sunset",
            "Try local seafood restaurants",
            "Learn surfing basics"
          ],
          "transportationOptions": [
            "Train to Weligama",
            "Private taxi",
            "Public bus",
            "Tuk-tuk from nearby towns"
          ],
          "weatherInfo": {
            "summerTemp": "26-31°C",
            "winterTemp": "25-29°C",
            "rainySeasons": ["May", "October"]
          }
        },
        "hikkaduwa-001": {
          "id": "hikkaduwa-001",
          "name": "Hikkaduwa",
          "description": "Vibrant beach town known for coral reefs, surfing, and sea turtle sightings.",
          "imageUrl": "[storage_url]/hikkaduwa_main.jpg",
          "latitude": 6.1395,
          "longitude": 80.1017,
          "rating": 4.4,
          "activities": [
            "Snorkeling",
            "Surfing",
            "Glass bottom boat rides",
            "Turtle watching",
            "Beach parties"
          ],
          "category": ["beach", "water-sports", "nightlife"],
          "highlights": [
            "Coral Sanctuary",
            "Hikkaduwa Beach",
            "Turtle Hatchery",
            "Tsunami Museum",
            "Buddhist Temple"
          ],
          "bestTimeToVisit": "November to April",
          "localTips": [
            "Snorkel early morning for best visibility",
            "Feed turtles at designated areas only",
            "Book surf lessons in advance",
            "Visit coral reefs during high tide"
          ],
          "transportationOptions": [
            "Train from Colombo",
            "Private taxi",
            "Public bus",
            "Tuk-tuk for local travel"
          ],
          "weatherInfo": {
            "summerTemp": "26-31°C",
            "winterTemp": "25-29°C",
            "rainySeasons": ["May", "October"]
          }
        }
      }
      ''';

      final Map<String, dynamic> data = json.decode(jsonString);

      // Create a batch
      WriteBatch batch = _firestore.batch();

      // Add each destination to the batch
      data.forEach((key, value) {
        DocumentReference docRef = _firestore.collection('destinations').doc(key);
        batch.set(docRef, value);
      });

      // Commit the batch
      await batch.commit();
      print('Destinations uploaded successfully');
    } catch (e) {
      print('Error uploading destinations: $e');
      rethrow;
    }
  }

  // Get destinations by category
  Future<List<Map<String, dynamic>>> getDestinationsByCategory(String category) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('destinations')
          .where('category', arrayContains: category)
          .get();

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error getting destinations by category: $e');
      return [];
    }
  }

  // Update destination rating
  Future<void> updateDestinationRating(String destinationId, double newRating) async {
    try {
      await _firestore.collection('destinations').doc(destinationId).update({
        'rating': newRating,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      print('Rating updated successfully');
    } catch (e) {
      print('Error updating rating: $e');
      rethrow;
    }
  }

  // Get nearby destinations based on coordinates
  Future<List<Map<String, dynamic>>> getNearbyDestinations(
      double latitude,
      double longitude,
      double radiusInKm,
      ) async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('destinations').get();

      List<Map<String, dynamic>> nearbyDestinations = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final destLat = data['latitude'] as double;
        final destLong = data['longitude'] as double;

        final distance = _calculateDistance(
          latitude,
          longitude,
          destLat,
          destLong,
        );

        if (distance <= radiusInKm) {
          nearbyDestinations.add(data);
        }
      }

      return nearbyDestinations;
    } catch (e) {
      print('Error getting nearby destinations: $e');
      return [];
    }
  }

  // Calculate distance between two coordinates using Haversine formula
  double _calculateDistance(
      double lat1,
      double lon1,
      double lat2,
      double lon2,
      ) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    double toRadians(double degree) {
      return degree * (pi / 180);
    }

    final dLat = toRadians(lat2 - lat1);
    final dLon = toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(toRadians(lat1)) *
            cos(toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  // Get all destinations
  Future<List<Map<String, dynamic>>> getAllDestinations() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('destinations').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error getting all destinations: $e');
      return [];
    }
  }

  // Get destination by ID
  Future<Map<String, dynamic>?> getDestinationById(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection('destinations').doc(id).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error getting destination by ID: $e');
      return null;
    }
  }

  // Search destinations by name
  Future<List<Map<String, dynamic>>> searchDestinations(String searchTerm) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('destinations')
          .where('name', isGreaterThanOrEqualTo: searchTerm)
          .where('name', isLessThan: searchTerm + 'z')
          .get();

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error searching destinations: $e');
      return [];
    }
  }

  // Get destinations by rating range
  Future<List<Map<String, dynamic>>> getDestinationsByRatingRange(double minRating, double maxRating) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('destinations')
          .where('rating', isGreaterThanOrEqualTo: minRating)
          .where('rating', isLessThanOrEqualTo: maxRating)
          .get();

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error getting destinations by rating range: $e');
      return [];
    }
  }

  // Toggle destination favorite status (used with user authentication)
  Future<void> toggleFavorite(String destinationId, bool isFavorite) async {
    try {
      await _firestore.collection('destinations').doc(destinationId).update({
        'isFavorite': isFavorite,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      print('Favorite status updated successfully');
    } catch (e) {
      print('Error updating favorite status: $e');
      rethrow;
    }
  }
}