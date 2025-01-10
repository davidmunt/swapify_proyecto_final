import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';
import 'package:swapify/presentation/widgets/alertdialog_logout.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
            if (state.user?.id != null && state.user?.email != null) {
              print('${state.user?.linkAvatar}');
              print('${state.user?.linkAvatar}');
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  if (state.user?.linkAvatar != null)
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage('$baseUrl${state.user?.linkAvatar}'),
                    )
                  else
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('assets/images/user_logo.png'),
                    ),
                  const SizedBox(height: 12),
                  Text(state.user?.email ?? "email desconocido"),
                  const SizedBox(height: 12),
                  Text(state.user?.name ?? "nombre desconocido"),
                  const SizedBox(height: 12),
                  const Divider(
                    color: Color.fromARGB(255, 84, 84, 84),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      context.go('/profile');
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 10),
                        Text("Perfil"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      context.go('/config_and_privacy');
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.lock),
                        SizedBox(width: 10),
                        Text("Configuracion y privacidad"),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            title: Text("¿Estas seguro de cerrar sesion?"),
                            content: AlertLogout(),
                          );
                        },
                      );
                    },
                    child: const Text("Logout"),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: Image.asset("assets/images/logo_fin_img.png", fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 12),
                  const Divider(
                    color: Color.fromARGB(255, 84, 84, 84),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.person_3_outlined),
                        SizedBox(width: 10),
                        Text("Iniciar sesion"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}