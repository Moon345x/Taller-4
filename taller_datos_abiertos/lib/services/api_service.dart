import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/department_model.dart';
import '../models/president_model.dart';
import '../models/region_model.dart';
import '../models/tourist_attraction_model.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  String get _baseUrl {
    final url = dotenv.env['API_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('API_URL is not configured in the .env file.');
    }
    return url;
  }

  Future<List<DepartmentModel>> getDepartments() async {
    final data = await _getList('/Department');
    return data.map(DepartmentModel.fromJson).toList();
  }

  Future<DepartmentModel> getDepartmentById(int id) async {
    final data = await _getById('/Department/$id');
    return DepartmentModel.fromJson(data);
  }

  Future<List<PresidentModel>> getPresidents() async {
    final data = await _getList('/President');
    return data.map(PresidentModel.fromJson).toList();
  }

  Future<PresidentModel> getPresidentById(int id) async {
    final data = await _getById('/President/$id');
    return PresidentModel.fromJson(data);
  }

  Future<List<RegionModel>> getRegions() async {
    final data = await _getList('/Region');
    return data.map(RegionModel.fromJson).toList();
  }

  Future<RegionModel> getRegionById(int id) async {
    final data = await _getById('/Region/$id');
    return RegionModel.fromJson(data);
  }

  Future<List<TouristAttractionModel>> getTouristAttractions() async {
    final data = await _getList('/TouristicAttraction');
    return data.map(TouristAttractionModel.fromJson).toList();
  }

  Future<TouristAttractionModel> getTouristAttractionById(int id) async {
    final data = await _getById('/TouristicAttraction/$id');
    return TouristAttractionModel.fromJson(data);
  }

  Future<List<Map<String, dynamic>>> _getList(String endpoint) async {
    try {
      final response = await _client.get(Uri.parse('$_baseUrl$endpoint'));
      if (response.statusCode != 200) {
        throw Exception(
          'Request to $endpoint failed with status ${response.statusCode}.',
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        throw Exception('Unexpected response format for $endpoint.');
      }

      return decoded
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } catch (error) {
      throw Exception('Error while fetching $endpoint: $error');
    }
  }

  Future<Map<String, dynamic>> _getById(String endpoint) async {
    try {
      final response = await _client.get(Uri.parse('$_baseUrl$endpoint'));
      if (response.statusCode != 200) {
        throw Exception(
          'Request to $endpoint failed with status ${response.statusCode}.',
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map) {
        throw Exception('Unexpected response format for $endpoint.');
      }

      return Map<String, dynamic>.from(decoded);
    } catch (error) {
      throw Exception('Error while fetching $endpoint: $error');
    }
  }
}