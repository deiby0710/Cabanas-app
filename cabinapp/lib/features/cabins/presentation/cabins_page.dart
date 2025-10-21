import 'package:flutter/material.dart';

class CabinsPage extends StatelessWidget {
  const CabinsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cabañas')),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Center(
              child: Text(
                'Cabaña ${index + 1}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
        },
      ),
    );
  }
}
