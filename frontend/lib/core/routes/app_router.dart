import 'package:go_router/go_router.dart';
import 'package:frontend/features/splash/presentation/splash_page.dart';
import 'package:frontend/features/auth/presentation/pages/login_page.dart';
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
  ],
);