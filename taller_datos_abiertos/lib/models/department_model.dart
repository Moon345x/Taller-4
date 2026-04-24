class DepartmentModel {
  const DepartmentModel({
    required this.id,
    this.name,
    this.description,
    this.cityCapitalId,
    this.municipalities,
    this.surface,
    this.population,
    this.phonePrefix,
    required this.countryId,
    this.cityCapital,
    this.country,
    this.cities,
    this.regionId,
    this.region,
    this.naturalAreas,
    this.maps,
    this.indigenousReservations,
    this.airports,
  });

  final int id;
  final String? name;
  final String? description;
  final int? cityCapitalId;
  final int? municipalities;
  final double? surface;
  final double? population;
  final String? phonePrefix;
  final int countryId;
  final Map<String, dynamic>? cityCapital;
  final Map<String, dynamic>? country;
  final List<Map<String, dynamic>>? cities;
  final int? regionId;
  final Map<String, dynamic>? region;
  final List<Map<String, dynamic>>? naturalAreas;
  final List<Map<String, dynamic>>? maps;
  final List<Map<String, dynamic>>? indigenousReservations;
  final List<Map<String, dynamic>>? airports;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: _toInt(json['id']) ?? 0,
      name: json['name'] as String?,
      description: json['description'] as String?,
      cityCapitalId: _toInt(json['cityCapitalId']),
      municipalities: _toInt(json['municipalities']),
      surface: _toDouble(json['surface']),
      population: _toDouble(json['population']),
      phonePrefix: json['phonePrefix'] as String?,
      countryId: _toInt(json['countryId']) ?? 0,
      cityCapital: _toMap(json['cityCapital']),
      country: _toMap(json['country']),
      cities: _toMapList(json['cities']),
      regionId: _toInt(json['regionId']),
      region: _toMap(json['region']),
      naturalAreas: _toMapList(json['naturalAreas']),
      maps: _toMapList(json['maps']),
      indigenousReservations: _toMapList(json['indigenousReservations']),
      airports: _toMapList(json['airports']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cityCapitalId': cityCapitalId,
      'municipalities': municipalities,
      'surface': surface,
      'population': population,
      'phonePrefix': phonePrefix,
      'countryId': countryId,
      'cityCapital': cityCapital,
      'country': country,
      'cities': cities,
      'regionId': regionId,
      'region': region,
      'naturalAreas': naturalAreas,
      'maps': maps,
      'indigenousReservations': indigenousReservations,
      'airports': airports,
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

  static double? _toDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  static Map<String, dynamic>? _toMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  static List<Map<String, dynamic>>? _toMapList(dynamic value) {
    if (value is! List) {
      return null;
    }

    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}