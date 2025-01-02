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

  Destination copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    double? latitude,
    double? longitude,
    double? rating,
    List<String>? activities,
    List<String>? category,
    List<String>? highlights,
    String? bestTimeToVisit,
    List<String>? localTips,
    List<String>? transportationOptions,
    Map<String, dynamic>? weatherInfo,
    bool? isFavorite,
  }) {
    return Destination(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      activities: activities ?? this.activities,
      category: category ?? this.category,
      highlights: highlights ?? this.highlights,
      bestTimeToVisit: bestTimeToVisit ?? this.bestTimeToVisit,
      localTips: localTips ?? this.localTips,
      transportationOptions: transportationOptions ?? this.transportationOptions,
      weatherInfo: weatherInfo ?? this.weatherInfo,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

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