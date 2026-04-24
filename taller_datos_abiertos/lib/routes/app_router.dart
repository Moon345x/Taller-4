import 'package:go_router/go_router.dart';

import '../views/dashboard_view.dart';
import '../views/detail_view.dart';
import '../views/list_view.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      name: RouteNames.dashboard,
      path: '/',
      builder: (context, state) => const DashboardView(),
    ),
    GoRoute(
      name: RouteNames.list,
      path: '/list/:type',
      builder: (context, state) {
        final type = state.pathParameters['type'] ?? '';
        return EntityListView(type: type);
      },
    ),
    GoRoute(
      name: RouteNames.detail,
      path: '/detail/:type/:id',
      builder: (context, state) {
        final type = state.pathParameters['type'] ?? '';
        final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
        return EntityDetailView(type: type, id: id);
      },
    ),
  ],
);
