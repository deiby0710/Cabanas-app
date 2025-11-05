import 'package:cabinapp/features/cabins/presentation/create_cabin_page.dart';
import 'package:cabinapp/features/customers/presentation/create_customer_page.dart';
import 'package:cabinapp/features/reservations/domain/reservation_model.dart';
import 'package:cabinapp/features/reservations/presentation/create_reservation_page.dart';
import 'package:cabinapp/features/reservations/presentation/widgets/edit_reservation_modal.dart';
import 'package:go_router/go_router.dart';
import 'package:cabinapp/features/splash/presentation/splash_page.dart';
import 'package:cabinapp/features/auth/presentation/auth_page.dart';
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
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: '/selectOrganization',
      builder: (context, state) => const SelectOrganizationPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/createCabin',
      builder: (context, state) => const CreateCabinPage(),
    ),
    GoRoute(
      path: '/customers/create',
      builder: (context, state) => const CreateCustomerPage(),
    ),
    GoRoute(
      path: '/reservations/create',
        builder: (context, state) {
        final startDate = state.extra as DateTime?;
        return CreateReservationPage(startDate: startDate ?? DateTime.now());
      }
    ),
    GoRoute(
      path: '/reservations/edit',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final reservation = extra?['reservation'] as ReservationModel;
        return EditReservationModal(reservation: reservation);
      },
    ),
  ],
);