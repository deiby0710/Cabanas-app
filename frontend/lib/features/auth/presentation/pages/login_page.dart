import 'package:flutter/material.dart';
import 'package:frontend/features/auth/presentation/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo o encabezado
                Image.asset(
                  'assets/images/cabana.png',
                  width: size.width * 0.4,
                ),

                const SizedBox(height: 20),

                Text(
                  'Bienvenido',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 40),

                // Formulario de login
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: LoginForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
