import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';
import 'package:swapify/presentation/widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Swapify"),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.errorMessage == null) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Bienvenido a la Home Screen"),
                  Text("Nombre de usuario"),
                ],
              ),
            );
          } else if (state.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Ha habido un error: ${state.errorMessage}"),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text("Ha habido un error, vuelvelo a intentar mas tarde"),
            );
          }
        },
      ),
      drawer: const Drawer(
        child: DrawerWidget(),
      ),
    );
  }
}
