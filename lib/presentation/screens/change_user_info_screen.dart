import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swapify/injection.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_event.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';
import 'package:swapify/presentation/widgets/widget_select_date.dart';
import 'package:swapify/presentation/widgets/widget_text_form.dart';
import 'package:flutter/services.dart';

//pantalla que permite al usuario modificar su informacion como nombre, apellidos, telefono y fecha de nacimiento
class ChangeUserInfoScreen extends StatefulWidget {
  const ChangeUserInfoScreen({super.key});

  @override
  State<ChangeUserInfoScreen> createState() => ChangeUserInfoScreenState();
}

class ChangeUserInfoScreenState extends State<ChangeUserInfoScreen> {
  DateTime? selectedDate;
  late TextEditingController nombreController;
  late TextEditingController apellidosController;
  late TextEditingController telefonoController;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController();
    apellidosController = TextEditingController();
    telefonoController = TextEditingController();
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidosController.dispose();
    telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.changeUserInfo),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage ?? AppLocalizations.of(context)!.error)));
            } else if (state.errorMessage == null && !state.isLoading) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.userInfoChanged)));
              context.push('/home');
            }
          },
          builder: (context, state) {
            if (state.user != null && selectedDate == null) {
              selectedDate = state.user?.dateBirth;
              nombreController.text = state.user?.name ?? '';
              apellidosController.text = state.user?.surname ?? '';
              telefonoController.text = state.user?.telNumber?.toString() ?? '';
            }
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
                  texto: AppLocalizations.of(context)!.name,
                  iconoHint: const Icon(Icons.person),
                  controller: nombreController,
                ),
                const SizedBox(height: 12),
                WidgetTextoFormulario(
                  texto: AppLocalizations.of(context)!.surnames,
                  iconoHint: const Icon(Icons.person),
                  controller: apellidosController,
                ),
                const SizedBox(height: 12),
                WidgetTextoFormulario(
                  texto: AppLocalizations.of(context)!.phone,
                  iconoHint: const Icon(Icons.phone),
                  controller: telefonoController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 12),
                WidgetFechaNacimiento(
                  selectedDate: selectedDate,
                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextButton(
                    onPressed: () {
                      final name = nombreController.text.trim();
                      final surname = apellidosController.text.trim();
                      final telNumber = telefonoController.text.trim();
                      final telNumberParsed = int.tryParse(telNumber);
                  
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
                      } else if (telNumberParsed == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldPhone)));
                        return;
                      } else if (telNumber.length < 8) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldPhoneShort)));
                        return;
                      } else if (selectedDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldDatebirth)));
                        return;
                      }
                      final prefs = sl<SharedPreferences>();
                      final id = prefs.getString('id');
                      context.read<UserBloc>().add(ChangeUserInfoButtonPressed(
                        uid: id ?? "Desconocido",
                        name: name,
                        surname: surname,
                        telNumber: telNumberParsed,
                        dateBirth: selectedDate!,
                      ));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 10, 185, 121),
                      minimumSize: const Size(double.infinity, 70), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.changeUserInfo,
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
