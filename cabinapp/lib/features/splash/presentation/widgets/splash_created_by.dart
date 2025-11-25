import 'package:cabinapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashCreatedBy extends StatelessWidget {
  final Color color;

  const SplashCreatedBy({
    super.key,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Animate(
      effects: [
        FadeEffect(
          duration: 1500.ms,
          delay: 4000.ms,
        ),
        SlideEffect(
          begin: const Offset(0, 2),
          end: const Offset(0, 0),
          duration: 1000.ms,
          delay: 4000.ms,
        ),
      ],
      child: Column(
        children: [
          Text(
            local.createdByLabel, 
            style: GoogleFonts.poppins(
              color: theme.colorScheme.onPrimary.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Alejandro Delgado & Santiago Enriquez',
            style: GoogleFonts.poppins(
              color: theme.colorScheme.onPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}