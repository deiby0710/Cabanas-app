import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomerCard extends StatelessWidget {
  final String name;
  final String email;
  final int index;

  const CustomerCard({
    super.key,
    required this.name,
    required this.email,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(
          name,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(
          email,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
        ),
      ),
    )
        // 👇 Animación con flutter_animate
        .animate()
        .fadeIn(duration: 400.ms, delay: (index * 100).ms)
        .scale(begin: const Offset(0.9, 0.9))
        .move(begin: const Offset(0, 20), curve: Curves.easeOut);
  }
}
