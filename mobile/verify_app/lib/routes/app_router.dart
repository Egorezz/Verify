import 'package:auto_route/auto_route.dart';
import 'package:verify_app/routes/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: WelcomeRoute.page, path: '/', initial: true),
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: RegistrationRoute.page, path: '/register'),
    AutoRoute(page: ScanRoute.page, path: '/scan'),
  ];
}
