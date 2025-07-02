import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_event.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';
import 'package:swapify/presentation/widgets/widget_text_form.dart';

//pantalla para hacer login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPass = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.user?.email != null &&
              state.user?.email != "NO_USER" &&
              state.errorMessage == null) {
                Future.microtask(() {
                  context.pushReplacement('/home', extra: state.user?.email);
                });
                if (state.errorMessage != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage ?? AppLocalizations.of(context)!.unexpectedError)));
                  });
                }
              }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
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
                const SizedBox(height: 20),
                WidgetTextoFormulario(
                  texto: AppLocalizations.of(context)!.password,
                  iconoHint: const Icon(Icons.lock),
                  onPressed: () {
                    setState(() {
                      showPass = !showPass;
                    });
                  },
                  icon: showPass ? Icons.visibility_off : Icons.visibility,
                  obscureText: !showPass,
                  controller: passwordController,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.forgotPassword, style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {
                        context.push('/reset_password');
                      },
                      child: Text(
                        AppLocalizations.of(context)!.clickHere,
                        style: const TextStyle(color: Color.fromARGB(255, 10, 185, 121)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextButton(
                    onPressed: () {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();
                      if (email.length < 4) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldEmailShort)));
                        return;
                      } else if (!email.contains("@") || email.startsWith('@') || email.endsWith('@')) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldFormatEmail)));
                        return;
                      } else if (password.length < 4) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.shortPassword)));
                        return;
                      }
                      context.read<UserBloc>().add(LoginButtonPressed(email: email, password: password));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 10, 185, 121),
                      minimumSize: const Size(double.infinity, 70), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.login,
                      style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextButton(
                    onPressed: () {
                      context.push('/create_acount');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 70), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.register,
                      style: const TextStyle(color: Color.fromARGB(255, 10, 185, 121), fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
