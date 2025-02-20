import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';

class UserInfoDrawer extends StatefulWidget {
  const UserInfoDrawer({super.key});

  @override
  State<UserInfoDrawer> createState() => _UserInfoDrawerState();
}

class _UserInfoDrawerState extends State<UserInfoDrawer> {
  @override
  Widget build(BuildContext context) {
    final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.changeUserInfo),
        centerTitle: true,
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.errorMessage == null && state.user != null) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blueGrey,
                    backgroundImage: state.user!.linkAvatar?.isNotEmpty == true ? NetworkImage("$baseUrl${state.user!.linkAvatar!}") : null,
                    child: state.user!.linkAvatar?.isEmpty ?? true ? Text(state.user!.name![0].toUpperCase(), style: const TextStyle(fontSize: 40, color: Colors.white)) : null,
                  ),
                  const SizedBox(height: 25),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.person, color: Colors.blueGrey),
                              title: Text("${state.user!.name} ${state.user!.surname}", style: const TextStyle(fontSize: 16)),
                            ),
                            const Divider(height: 1, thickness: 1, color: Colors.grey),
                          ],
                        ),
                        Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.email, color: Colors.blueGrey),
                              title: Text(state.user!.email, style: const TextStyle(fontSize: 16)),
                            ),
                            const Divider(height: 1, thickness: 1, color: Colors.grey),
                          ],
                        ),
                        Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.phone, color: Colors.blueGrey),
                              title: Text(state.user!.telNumber.toString(), style: const TextStyle(fontSize: 16)),
                            ),
                            const Divider(height: 1, thickness: 1, color: Colors.grey),
                          ],
                        ),
                        Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.date_range, color: Colors.blueGrey),
                              title: Text(
                                state.user!.dateBirth != null 
                                    ? DateFormat('dd/MM/yyyy').format(state.user!.dateBirth!) 
                                    : 'Fecha no disponible',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            const Divider(height: 1, thickness: 1, color: Colors.grey),
                          ],
                        ),
                        Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.account_balance_wallet, color: Colors.blueGrey),
                              title: Text("${state.user!.balance}€", style: const TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  TextButton(
                    onPressed: () {
                      context.push('/profile');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.edit_note_rounded),
                        const SizedBox(width: 10),
                        Text(AppLocalizations.of(context)!.change),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.errorComeLater,
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    );
  }
}
