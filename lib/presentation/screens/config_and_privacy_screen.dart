import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';

class ConfigAndPrivacyScreen extends StatefulWidget {
  const ConfigAndPrivacyScreen({super.key});

  @override
  State<ConfigAndPrivacyScreen> createState() => _ConfigAndPrivacyScreenState();
}

class _ConfigAndPrivacyScreenState extends State<ConfigAndPrivacyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuración y Privacidad"),
        centerTitle: true,
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.errorMessage == null) {
            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () => context.go('/change_password'),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(200, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_person),
                        SizedBox(width: 8),
                        Text("Cambiar contraseña"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1.0,
                  ),
                  const SizedBox(height: 12),
                  const Text("Notificaciones: "),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                  children: [
                    Text(
                      "Ha habido un error: ${state.errorMessage}, intentalo mas tarde",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
            );
          }
        },
      ),
    );
  }
}
