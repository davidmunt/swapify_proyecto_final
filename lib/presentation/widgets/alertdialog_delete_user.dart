import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_event.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';

class AlertDeleteAcount extends StatefulWidget {
  const AlertDeleteAcount({super.key});

  @override
  State<AlertDeleteAcount> createState() => _AlertDeleteAcountState();
}

class _AlertDeleteAcountState extends State<AlertDeleteAcount> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
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
                    final userId = state.user?.id;
                    if (userId != null) {
                      context.read<UserBloc>().add(DeleteUserButtonPressed(id: userId));
                      context.read<UserBloc>().add(LogoutButtonPressed());
                      Navigator.of(context).pop();
                      context.go('/login');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No se pudo eliminar el usuario")),
                      );
                    }
                  },
                  child: const Text("Eliminar usuario"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}