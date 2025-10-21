import 'package:go_router/go_router.dart';
import 'package:cabinapp/features/splash/presentation/splash_page.dart';
import 'package:cabinapp/features/auth/presentation/login_page.dart';
import 'package:cabinapp/features/organization/presentation/organization_page.dart';
import 'package:cabinapp/features/home/presentation/home_page.dart';
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