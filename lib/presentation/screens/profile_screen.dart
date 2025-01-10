import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';
import 'package:swapify/presentation/widgets/alertdialog_delete_user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
        centerTitle: true,
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.errorMessage == null) {
            return Center(
              child: Column(
                  children: [
                    const SizedBox(height: 30),
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
                    const SizedBox(height: 16),
                    Text(state.user?.name ?? "Nombre"),
                    const SizedBox(height: 8),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        context.go('/change_user_info');
                      } ,
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
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text("Cambiar datos del usuario"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        context.go('/change_user_avatar');
                      } ,
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
                          Icon(Icons.account_circle),
                          SizedBox(width: 8),
                          Text("Cambiar foto de perfil"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text("¿Estas seguro de eliminar la cuenta?"),
                              content: AlertDeleteAcount(),
                            );
                          },
                        );
                      } ,
                      style: TextButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.red.withOpacity(0.1),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Eliminar cuenta", style: TextStyle(fontSize: 16, color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
            );
          } else {
            return Center(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Ha habido un error: ${state.errorMessage}, intentalo mas tarde",
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
