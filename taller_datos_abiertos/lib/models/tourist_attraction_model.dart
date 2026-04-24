class TouristAttractionModel {
  const TouristAttractionModel({
    required this.id,
    this.name,
    this.description,
    this.images,
    this.latitude,
    this.longitude,
    required this.cityId,
    this.city,
  });

  final int id;
  final String? name;
  final String? description;
  final List<String>? images;
  final String? latitude;
  final String? longitude;
  final int cityId;
  final Map<String, dynamic>? city;

  factory TouristAttractionModel.fromJson(Map<String, dynamic> json) {
    return TouristAttractionModel(
      id: _toInt(json['id']) ?? 0,
      name: json['name'] as String?,
      description: json['description'] as String?,
      images: _toStringList(json['images']),
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      cityId: _toInt(json['cityId']) ?? 0,
      city: _toMap(json['city']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images,
      'latitude': latitude,
      'longitude': longitude,
      'cityId': cityId,
      'city': city,
    };
  }

  static int? _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  static Map<String, dynamic>? _toMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  static List<String>? _toStringList(dynamic value) {
    if (value is! List) {
      return null;
    }

    return value.map((item) => item.toString()).toList();
  }
}
