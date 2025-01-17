import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_event.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';
import 'package:swapify/presentation/widgets/widget_select_date.dart';
import 'package:swapify/presentation/widgets/widget_text_form.dart';

class CreateAcountScreen extends StatefulWidget {
  const CreateAcountScreen({super.key});

  @override
  State<CreateAcountScreen> createState() => CreateAcountScreenState();
}

class CreateAcountScreenState extends State<CreateAcountScreen> {
  DateTime? selectedDate;
  bool showPass = false;
  bool showPass2 = false;
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController contraController = TextEditingController();
  final TextEditingController contra2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.createAcount),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage ?? AppLocalizations.of(context)!.error)),
              );
            } else if (state.errorMessage == null && !state.isLoading) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.createdUser)));
              context.push('/home');
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                WidgetTextoFormulario(texto: AppLocalizations.of(context)!.name, iconoHint: const Icon(Icons.person), controller: nombreController),
                const SizedBox(height: 12),
                WidgetTextoFormulario(texto: AppLocalizations.of(context)!.surnames, iconoHint: const Icon(Icons.person), controller: apellidosController),
                const SizedBox(height: 12),
                WidgetTextoFormulario(texto: AppLocalizations.of(context)!.email, iconoHint: const Icon(Icons.alternate_email), controller: emailController),
                const SizedBox(height: 12),
                WidgetTextoFormulario(texto: AppLocalizations.of(context)!.phone, iconoHint: const Icon(Icons.phone), controller: telefonoController),
                const SizedBox(height: 12),
                WidgetFechaNacimiento(
                  selectedDate: selectedDate,
                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
                const SizedBox(height: 12),
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
                  controller: contraController,
                ),
                const SizedBox(height: 12),
                WidgetTextoFormulario(
                  texto: AppLocalizations.of(context)!.confirmPassword,
                  iconoHint: const Icon(Icons.lock),
                  onPressed: () {
                    setState(() {
                      showPass2 = !showPass2;
                    });
                  },
                  icon: showPass2 ? Icons.visibility_off : Icons.visibility,
                  obscureText: !showPass2,
                  controller: contra2Controller,
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextButton(
                    onPressed: () {
                      final name = nombreController.text.trim();
                      final surname = apellidosController.text.trim();
                      final email = emailController.text.trim();
                      final telNumber = telefonoController.text.trim();
                      int? telNumberParsed = int.tryParse(telNumber);
                      final password = contraController.text.trim();
                      final password2 = contra2Controller.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldName)));
                        return;
                      } else if (name.length < 2) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldNameShort)));
                        return;
                      } else if (surname.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldSurname)));
                        return;
                      } else if (surname.length < 2) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldSurnameShort)));
                        return;
                      } else if (email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldemail)));
                        return;
                      } else if (email.length < 4) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldEmailShort)));
                        return;
                      } else if (!email.contains("@") || email.startsWith('@') || email.endsWith('@')) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldFormatEmail)));
                        return;
                      } else if (telNumberParsed == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldPhone)));
                        return;
                      } else if (telNumber.length < 8) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldPhoneShort)));
                        return;
                      } else if (selectedDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldDatebirth)));
                        return;
                      } else if (password.length < 8 || password2.length < 8) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.shortPassword)));
                        return;
                      } else if (password.isEmpty || password2.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorPasswordRequired)));
                        return;
                      } else if (password != password2) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.notEqualsPasswords)));
                        return;
                      }
                      context.read<UserBloc>().add(SignUpButtonPressed(email: email, password: password, name: name, surname: surname, telNumber: telNumberParsed, dateBirth: selectedDate!));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 10, 185, 121),
                      minimumSize: const Size(double.infinity, 70), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.createAcountAndLogin,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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