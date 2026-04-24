import 'package:flutter/material.dart' hide ErrorWidget;

import '../services/api_service.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

class EntityDetailView extends StatefulWidget {
  const EntityDetailView({super.key, required this.type, required this.id});

  final String type;
  final int id;

  @override
  State<EntityDetailView> createState() => _EntityDetailViewState();
}

class _EntityDetailViewState extends State<EntityDetailView> {
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = _loadDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailFuture,
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

          final data = snapshot.data;
          if (data == null) {
            return ErrorWidget(
              message: 'No se encontro informacion del recurso.',
              onRetry: _retry,
            );
          }

          final title = _titleFor(widget.type, data);
          final imageUrl = _imageUrlFor(widget.type, data);
          final metadata = _buildMetadata(widget.type, data);

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 260,
                title: Text(_screenTitle(widget.type)),
                flexibleSpace: FlexibleSpaceBar(
                  background: _HeaderBackground(
                    imageUrl: imageUrl,
                    title: title,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      if ((data['description'] ?? '').toString().isNotEmpty)
                        Text(
                          data['description'].toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      const SizedBox(height: 20),
                      ...metadata.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  entry.key,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 5,
                                child: Text(
                                  entry.value,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _retry() {
    setState(() {
      _detailFuture = _loadDetail();
    });
  }

  Future<Map<String, dynamic>> _loadDetail() async {
    switch (_normalizeType(widget.type)) {
      case 'departments':
        return (await _apiService.getDepartmentById(widget.id)).toJson();
      case 'presidents':
        return (await _apiService.getPresidentById(widget.id)).toJson();
      case 'regions':
        return (await _apiService.getRegionById(widget.id)).toJson();
      case 'attractions':
        return (await _apiService.getTouristAttractionById(widget.id)).toJson();
      default:
        throw Exception('Tipo de detalle no soportado: ${widget.type}');
    }
  }
}

class _HeaderBackground extends StatelessWidget {
  const _HeaderBackground({required this.imageUrl, required this.title});

  final String? imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.startsWith('http')) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.network(imageUrl!, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.1),
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.tertiaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
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
      return 'Detalle del departamento';
    case 'presidents':
      return 'Detalle del presidente';
    case 'regions':
      return 'Detalle de la region';
    case 'attractions':
      return 'Detalle de atraccion';
    default:
      return 'Detalle';
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

String? _imageUrlFor(String type, Map<String, dynamic> data) {
  if (_normalizeType(type) == 'presidents') {
    return data['image']?.toString();
  }

  if (_normalizeType(type) == 'attractions') {
    final images = data['images'];
    if (images is List && images.isNotEmpty) {
      return images.first.toString();
    }
  }

  return null;
}

List<MapEntry<String, String>> _buildMetadata(
  String type,
  Map<String, dynamic> data,
) {
  switch (_normalizeType(type)) {
    case 'departments':
      return [
        MapEntry('ID', (data['id'] ?? 'N/D').toString()),
        MapEntry('Poblacion', (data['population'] ?? 'N/D').toString()),
        MapEntry('Superficie', (data['surface'] ?? 'N/D').toString()),
        MapEntry('Municipios', (data['municipalities'] ?? 'N/D').toString()),
        MapEntry(
          'Prefijo telefonico',
          (data['phonePrefix'] ?? 'N/D').toString(),
        ),
      ];
    case 'presidents':
      return [
        MapEntry('ID', (data['id'] ?? 'N/D').toString()),
        MapEntry(
          'Partido politico',
          (data['politicalParty'] ?? 'N/D').toString(),
        ),
        MapEntry(
          'Inicio de periodo',
          (data['startPeriodDate'] ?? 'N/D').toString(),
        ),
        MapEntry('Fin de periodo', (data['endPeriodDate'] ?? 'N/D').toString()),
      ];
    case 'regions':
      final departments = data['departments'];
      final count = departments is List ? departments.length : 0;
      return [
        MapEntry('ID', (data['id'] ?? 'N/D').toString()),
        MapEntry('Departamentos asociados', count.toString()),
      ];
    case 'attractions':
      return [
        MapEntry('ID', (data['id'] ?? 'N/D').toString()),
        MapEntry('Latitud', (data['latitude'] ?? 'N/D').toString()),
        MapEntry('Longitud', (data['longitude'] ?? 'N/D').toString()),
      ];
    default:
      return [MapEntry('ID', (data['id'] ?? 'N/D').toString())];
  }
}
