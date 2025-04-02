import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';
import 'package:swapify/presentation/widgets/alertdialog_delete_user.dart';

//pagina que te muestra tu informacion y botones para modificar tu usuario
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
        title: Text(AppLocalizations.of(context)!.profile),
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
                    Text(state.user?.name ?? AppLocalizations.of(context)!.name),
                    const SizedBox(height: 8),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        context.push('/change_user_info');
                      } ,
                      style: TextButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.edit),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.changeUserData),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        context.push('/change_user_avatar');
                      } ,
                      style: TextButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.account_circle),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.changeUserAvatar),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(AppLocalizations.of(context)!.areYouSureDeleteUserAccount),
                              content: const AlertDeleteAcount(),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.delete, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context)!.deleteUserAcount, style: const TextStyle(fontSize: 16, color: Colors.red)),
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
                    Text(AppLocalizations.of(context)!.errorComeLater,
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
