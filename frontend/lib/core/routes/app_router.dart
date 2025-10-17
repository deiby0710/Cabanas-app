import 'package:go_router/go_router.dart';
import 'package:frontend/features/splash/presentation/splash_page.dart';
import 'package:frontend/features/auth/presentation/pages/login_page.dart';
import 'package:frontend/features/organization/presentation/page/select_organization_page.dart';
import 'package:frontend/features/home/presentation/pages/home_page.dart';
// Luego agregarás más rutas aquí (por ejemplo home, profile, etc.)

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/selectOrganization',
      builder: (context, state) => const SelectOrganizationPage(),
      ),
      GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
      ),
  ],
);