import 'package:flutter/material.dart';
import 'package:swapify/presentation/widgets/alertdialog_logout.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Text('Usuario, ${state.user!.username}'),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              title: Text("¿Estás seguro de cerrar sesión?"),
                              content: AlertLogout(),
                            );
                          },
                        );
                      },
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              )
      ),
    );
  }
}