class RegionModel {
  const RegionModel({
    required this.id,
    this.name,
    this.description,
    this.departments,
  });

  final int id;
  final String? name;
  final String? description;
  final List<Map<String, dynamic>>? departments;

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: _toInt(json['id']) ?? 0,
      name: json['name'] as String?,
      description: json['description'] as String?,
      departments: _toMapList(json['departments']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'departments': departments,
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
