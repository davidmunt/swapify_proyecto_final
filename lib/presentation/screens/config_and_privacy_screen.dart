import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swapify/presentation/blocs/language/language_bloc.dart';
import 'package:swapify/presentation/blocs/language/language_event.dart';
import 'package:swapify/presentation/blocs/language/language_state.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';

//pantalla para cambiar el idioma y boton para la pantalla del cambio de contraseña
class ConfigAndPrivacyScreen extends StatefulWidget {
  const ConfigAndPrivacyScreen({super.key});

  @override
  State<ConfigAndPrivacyScreen> createState() => _ConfigAndPrivacyScreenState();
}

class _ConfigAndPrivacyScreenState extends State<ConfigAndPrivacyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsAndPrivacy),
        centerTitle: true,
      ),
      body: BlocConsumer<UserBloc, UserState>(
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
          } else if (state.errorMessage == null) {
            return Column(
              children: [
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () => context.push('/change_password'),
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
                      const Icon(Icons.lock_person),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.of(context)!.changePassword),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.grey, thickness: 1.0),
                const SizedBox(height: 12),
                Text(AppLocalizations.of(context)!.languageOfApp),
                //apartado para cambiar el idioma
                BlocBuilder<LanguageBloc, LanguageState>(
                  builder: (context, languageState) {
                    if (languageState.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Column(
                      children: [
                        _buildLanguageTile(
                          context,
                          'English',
                          const Locale('en'),
                          languageState.locale,
                        ),
                        _buildLanguageTile(
                          context,
                          'Español',
                          const Locale('es'),
                          languageState.locale,
                        ),
                        _buildLanguageTile(
                          context,
                          'Français',
                          const Locale('fr'),
                          languageState.locale,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.grey, thickness: 1.0),
                const SizedBox(height: 12),
              ],
            );
          } else {
            return Center(
              child: Text(AppLocalizations.of(context)!.errorComeLater, textAlign: TextAlign.center),
            );
          }
        },
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, String language, Locale locale, Locale currentLocale) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      title: Text(
        language,
        style: TextStyle(
          fontWeight: locale == currentLocale ? FontWeight.bold : FontWeight.normal,
          color: locale == currentLocale ? const Color.fromARGB(255, 10, 185, 121) : Colors.black,
          fontSize: 14.0,
        ),
      ),
      trailing: locale == currentLocale ? const Icon(Icons.check, color: Color.fromARGB(255, 10, 185, 121), size: 20.0) : null,
      onTap: () {
        context.read<LanguageBloc>().add(ChangeLanguageEvent(locale));
      },
    );
  }
}
