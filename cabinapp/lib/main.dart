import 'package:cabinapp/features/cabins/data/cabins_repository.dart';
import 'package:cabinapp/features/cabins/presentation/providers/cabins_provider.dart';
import 'package:cabinapp/features/customers/data/customers_repository.dart';
import 'package:cabinapp/features/customers/presentation/provider/customers_provider.dart';
import 'package:cabinapp/features/organization/data/organization_repository.dart';
import 'package:cabinapp/features/organization/presentation/providers/organization_provider.dart';
import 'package:cabinapp/features/reservations/data/reservations_repository.dart';
import 'package:cabinapp/features/reservations/presentation/provider/reservation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cabinapp/core/routes/app_router.dart';
import 'package:cabinapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:cabinapp/features/auth/data/auth_repository.dart';
import 'package:cabinapp/core/network/api_client.dart';
import 'package:cabinapp/core/theme/theme_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cabinapp/l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ✅ Aquí creamos el AuthProvider con el AuthRepository conectado al ApiClient
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            AuthRepository(dio: ApiClient.build()),
          ),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => OrganizationProvider(
            OrganizationRepository(dio: ApiClient.build()),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CabinsProvider(CabinsRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => CustomersProvider(CustomersRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => ReservationsProvider(ReservationsRepository()),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'CabinApp',
            theme: ThemeData.light(useMaterial3: true).copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.deepPurple.shade400,
                    width: 2,
                  ),
                ),
                labelStyle: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.grey[900],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.deepPurple.shade200,
                    width: 2,
                  ),
                ),
                labelStyle: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            themeMode: themeProvider.themeMode,
            routerConfig: appRouter,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('es'),
            ],
          );
        },
      ),
    );
  }
}
