import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_event.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';

class AlertLogout extends StatefulWidget {
  const AlertLogout({super.key});

  @override
  State<AlertLogout> createState() => _AlertLogoutState();
}

class _AlertLogoutState extends State<AlertLogout> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          // Puedes manejar el estado aquí si es necesario
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    context.read<UserBloc>().add(LogoutButtonPressed());
                    Navigator.of(context).pop();
                    context.go('/login');
                  },
                  child: const Text("Cerrar Sesion"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}