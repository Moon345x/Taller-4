import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:go_router/go_router.dart';

import '../routes/route_names.dart';
import '../services/api_service.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

class EntityListView extends StatefulWidget {
  const EntityListView({super.key, required this.type});

  final String type;

  @override
  State<EntityListView> createState() => _EntityListViewState();
}

class _EntityListViewState extends State<EntityListView> {
  final ApiService _apiService = ApiService();
  late Future<List<Map<String, dynamic>>> _entitiesFuture;

  @override
  void initState() {
    super.initState();
    _entitiesFuture = _loadEntities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_screenTitle(widget.type))),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _entitiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          }

          if (snapshot.hasError) {
            return ErrorWidget(
              message: snapshot.error.toString(),
              onRetry: _retry,
            );
          }

          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('No hay resultados para mostrar.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = items[index];
              final id = item['id'];
              final idText = id?.toString() ?? '0';

              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    _titleFor(widget.type, item),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    _subtitleFor(widget.type, item),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.pushNamed(
                      RouteNames.detail,
                      pathParameters: {'type': widget.type, 'id': idText},
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _retry() {
    setState(() {
      _entitiesFuture = _loadEntities();
    });
  }

  Future<List<Map<String, dynamic>>> _loadEntities() async {
    switch (_normalizeType(widget.type)) {
      case 'departments':
        final items = await _apiService.getDepartments();
        return items.map((item) => item.toJson()).toList();
      case 'presidents':
        final items = await _apiService.getPresidents();
        return items.map((item) => item.toJson()).toList();
      case 'regions':
        final items = await _apiService.getRegions();
        return items.map((item) => item.toJson()).toList();
      case 'attractions':
        final items = await _apiService.getTouristAttractions();
        return items.map((item) => item.toJson()).toList();
      default:
        throw Exception('Tipo de listado no soportado: ${widget.type}');
    }
  }
}

String _normalizeType(String type) {
  final value = type.trim().toLowerCase();
  if (value == 'tourist-attractions' || value == 'tourist_attractions') {
    return 'attractions';
  }
  return value;
}

String _screenTitle(String type) {
  switch (_normalizeType(type)) {
    case 'departments':
      return 'Departamentos';
    case 'presidents':
      return 'Presidentes';
    case 'regions':
      return 'Regiones';
    case 'attractions':
      return 'Atracciones turisticas';
    default:
      return 'Listado';
  }
}

String _titleFor(String type, Map<String, dynamic> data) {
  switch (_normalizeType(type)) {
    case 'presidents':
      final firstName = data['name']?.toString() ?? '';
      final lastName = data['lastName']?.toString() ?? '';
      final fullName = '$firstName $lastName'.trim();
      return fullName.isEmpty ? 'Sin nombre' : fullName;
    default:
      return data['name']?.toString() ?? 'Sin nombre';
  }
}

String _subtitleFor(String type, Map<String, dynamic> data) {
  switch (_normalizeType(type)) {
    case 'departments':
      final population = data['population'];
      final municipalities = data['municipalities'];
      return 'Poblacion: ${population ?? 'N/D'} | Municipios: ${municipalities ?? 'N/D'}';
    case 'presidents':
      return 'Partido: ${data['politicalParty'] ?? 'N/D'}';
    case 'regions':
      return data['description']?.toString() ?? 'Sin descripcion';
    case 'attractions':
      return data['description']?.toString() ?? 'Sin descripcion';
    default:
      return data['description']?.toString() ?? 'Sin descripcion';
  }
}
