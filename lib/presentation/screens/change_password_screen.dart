import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_event.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';
import 'package:swapify/presentation/widgets/widget_text_form.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController contraController = TextEditingController();
  final TextEditingController contra2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.changePassword),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage ?? AppLocalizations.of(context)!.error)),
              );
            } else if (state.errorMessage == null && !state.isLoading) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.passwordChanged)));
              context.push('/login');
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset("assets/images/logo_fin_img.png", fit: BoxFit.contain),
                ),
                const SizedBox(height: 40),
                WidgetTextoFormulario(texto: AppLocalizations.of(context)!.password, iconoHint: const Icon(Icons.lock), controller: contraController),
                const SizedBox(height: 12),
                WidgetTextoFormulario(texto: AppLocalizations.of(context)!.confirmPassword, iconoHint: const Icon(Icons.lock), controller: contra2Controller),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextButton(
                    onPressed: () {
                      final password = contraController.text.trim();
                      final password2 = contra2Controller.text.trim();
                      if (password.length < 8 || password2.length < 8) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.shortPassword)));
                        return;
                      } else if (password.isEmpty || password2.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorPasswordRequired)));
                        return;
                      } else if (password != password2) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.notEqualsPasswords)));
                        return;
                      }
                      context.read<UserBloc>().add(ChangePasswordButtonPressed(password: password));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 10, 185, 121),
                      minimumSize: const Size(double.infinity, 70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.changePassword, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            );
          },
        ),
      ),
    );
  }
}