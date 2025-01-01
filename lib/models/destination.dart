class Destination {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final double rating;
  final List<String> activities;
  final List<String> category;
  final List<String> highlights;
  final String bestTimeToVisit;
  final List<String> localTips;
  final List<String> transportationOptions;
  final Map<String, dynamic> weatherInfo;
  final bool isFavorite;

  Destination({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.activities,
    required this.category,
    required this.highlights,
    required this.bestTimeToVisit,
    required this.localTips,
    required this.transportationOptions,
    required this.weatherInfo,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'imageUrl': imageUrl,
    'latitude': latitude,
    'longitude': longitude,
    'rating': rating,
    'activities': activities,
    'category': category,
    'highlights': highlights,
    'bestTimeToVisit': bestTimeToVisit,
    'localTips': localTips,
    'transportationOptions': transportationOptions,
    'weatherInfo': weatherInfo,
    'isFavorite': isFavorite,
  };

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      activities: List<String>.from(json['activities'] ?? []),
      category: List<String>.from(json['category'] ?? []),
      highlights: List<String>.from(json['highlights'] ?? []),
      bestTimeToVisit: json['bestTimeToVisit'] ?? '',
      localTips: List<String>.from(json['localTips'] ?? []),
      transportationOptions: List<String>.from(json['transportationOptions'] ?? []),
      weatherInfo: json['weatherInfo'] ?? {},
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}