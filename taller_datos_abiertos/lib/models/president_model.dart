class PresidentModel {
  const PresidentModel({
    required this.id,
    this.image,
    this.name,
    this.lastName,
    this.startPeriodDate,
    this.endPeriodDate,
    this.politicalParty,
    this.description,
    required this.cityId,
    this.city,
  });

  final int id;
  final String? image;
  final String? name;
  final String? lastName;
  final String? startPeriodDate;
  final String? endPeriodDate;
  final String? politicalParty;
  final String? description;
  final int cityId;
  final Map<String, dynamic>? city;

  factory PresidentModel.fromJson(Map<String, dynamic> json) {
    return PresidentModel(
      id: _toInt(json['id']) ?? 0,
      image: json['image'] as String?,
      name: json['name'] as String?,
      lastName: json['lastName'] as String?,
      startPeriodDate: json['startPeriodDate'] as String?,
      endPeriodDate: json['endPeriodDate'] as String?,
      politicalParty: json['politicalParty'] as String?,
      description: json['description'] as String?,
      cityId: _toInt(json['cityId']) ?? 0,
      city: _toMap(json['city']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'lastName': lastName,
      'startPeriodDate': startPeriodDate,
      'endPeriodDate': endPeriodDate,
      'politicalParty': politicalParty,
      'description': description,
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
}
