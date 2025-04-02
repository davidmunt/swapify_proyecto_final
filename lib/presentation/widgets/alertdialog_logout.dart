import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_event.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';

//alert para confirmar que quieres añadirte cerrar la sesion
class AlertLogout extends StatefulWidget {
  const AlertLogout({super.key});

  @override
  State<AlertLogout> createState() => _AlertLogoutState();
}

class _AlertLogoutState extends State<AlertLogout> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                TextButton(
                  onPressed: () async {
                    if (userState.user != null) {
                      context.read<UserBloc>().add(SaveUserNotificationTokenButtonPressed(userId: userState.user!.id, notificationToken: null));
                    }
                    context.read<UserBloc>().add(LogoutButtonPressed());
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.logout),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
