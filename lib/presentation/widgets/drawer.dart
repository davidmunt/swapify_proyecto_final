import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.user?.id != null && state.user?.email != null) {
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
                  Text(state.user?.email ?? "Email desconocido"),
                  const SizedBox(height: 12),
                  Text(state.user?.name ?? "Nombre desconocido"),
                  const SizedBox(height: 12),
                  const Divider(color: Color.fromARGB(255, 84, 84, 84)),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      context.push('/user_info_drawer');
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 10),
                        Text(AppLocalizations.of(context)!.profile),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      context.push('/config_and_privacy');
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.lock),
                        const SizedBox(width: 10),
                        Text(AppLocalizations.of(context)!.settingsAndPrivacy),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      context.push('/qr_scanner');
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.qr_code_scanner),
                        SizedBox(width: 10),
                        Text("Vender producto"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      context.push('/qr_scanner_add_balance');
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.qr_code_scanner),
                        SizedBox(width: 10),
                        Text("Añadir saldo"),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(child: Text(AppLocalizations.of(context)!.areYouSureLogout, textAlign: TextAlign.center,)),
                            content: const AlertLogout(),
                          );
                        },
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.logout),
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
                  const Divider(color: Color.fromARGB(255, 84, 84, 84)),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      context.push('/login');
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.person_3_outlined),
                        const SizedBox(width: 10),
                        Text(AppLocalizations.of(context)!.login),
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
