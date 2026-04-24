import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routes/route_names.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  static const List<_DashboardItem> _items = [
    _DashboardItem(
      title: 'Departamentos',
      subtitle: 'Consulta informacion territorial',
      type: 'departments',
      icon: Icons.map_outlined,
      color: Color(0xFF0E7490),
    ),
    _DashboardItem(
      title: 'Presidentes',
      subtitle: 'Linea historica presidencial',
      type: 'presidents',
      icon: Icons.account_balance_outlined,
      color: Color(0xFF4D7C0F),
    ),
    _DashboardItem(
      title: 'Regiones',
      subtitle: 'Explora la organizacion regional',
      type: 'regions',
      icon: Icons.public_outlined,
      color: Color(0xFF7C3AED),
    ),
    _DashboardItem(
      title: 'Atracciones',
      subtitle: 'Turismo y lugares destacados',
      type: 'attractions',
      icon: Icons.landscape_outlined,
      color: Color(0xFFB45309),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos Abiertos de Colombia')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 840
                ? 4
                : constraints.maxWidth > 560
                ? 2
                : 1;

            return GridView.builder(
              itemCount: _items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: crossAxisCount == 1 ? 2.6 : 1.2,
              ),
              itemBuilder: (context, index) {
                final item = _items[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 0,
                  child: InkWell(
                    onTap: () {
                      context.pushNamed(
                        RouteNames.list,
                        pathParameters: {'type': item.type},
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            item.color,
                            item.color.withValues(alpha: 0.75),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(item.icon, color: Colors.white),
                          ),
                          const Spacer(),
                          Text(
                            item.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _DashboardItem {
  const _DashboardItem({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String type;
  final IconData icon;
  final Color color;
}
