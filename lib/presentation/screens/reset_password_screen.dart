import 'package:flutter/material.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_event.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';
import 'package:swapify/presentation/widgets/widget_text_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//pantalla para enviar al email un correo para cambiar la contraseña
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.retrivePassword),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? AppLocalizations.of(context)!.error)),
              );
            } else if (state.errorMessage == null && !state.isLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.retrivePasswordSend)),
              );
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
                WidgetTextoFormulario(
                  texto: AppLocalizations.of(context)!.email,
                  iconoHint: const Icon(Icons.alternate_email),
                  controller: emailController,
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextButton(
                    onPressed: () {
                    final email = emailController.text.trim();
                      if (email.length < 4) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldEmailShort)));
                        return;
                      } else if (!email.contains("@") || email.startsWith('@') || email.endsWith('@')) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldFormatEmail)));
                        return;
                      }
                      context.read<UserBloc>().add(ResetPasswordButtonPressed(email: email));
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 10, 185, 121),
                        minimumSize: const Size(double.infinity, 70),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: Text(AppLocalizations.of(context)!.retrivePassword, style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
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