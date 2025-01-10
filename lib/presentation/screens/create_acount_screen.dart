import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        title: const Text("Crear cuenta"),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage ?? "Ha habido un error")),
              );
            } else if (state.errorMessage == null && !state.isLoading) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Usuario creado")));
              context.go('/home');
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                WidgetTextoFormulario(texto: "Nombre", iconoHint: const Icon(Icons.person), controller: nombreController),
                const SizedBox(height: 12),
                WidgetTextoFormulario(texto: "Apellidos", iconoHint: const Icon(Icons.person), controller: apellidosController),
                const SizedBox(height: 12),
                WidgetTextoFormulario(texto: "Email", iconoHint: const Icon(Icons.alternate_email), controller: emailController),
                const SizedBox(height: 12),
                WidgetTextoFormulario(texto: "Telefono", iconoHint: const Icon(Icons.phone), controller: telefonoController),
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
                  texto: "Contraseña",
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
                  texto: "Confirma la Contraseña",
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
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tienes que rellenar el campo del nombre')));
                        return;
                      } else if (name.length < 2) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El nombre no puede ser tan corto')));
                        return;
                      } else if (surname.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tienes que rellenar el campo de apellidos')));
                        return;
                      } else if (surname.length < 2) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El apellido no puede ser tan corto')));
                        return;
                      } else if (email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tienes que rellenar el campo de email')));
                        return;
                      } else if (email.length < 4) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El email es demasiado corto')));
                        return;
                      } else if (!email.contains("@") || email.startsWith('@') || email.endsWith('@')) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El formato del email no es correcto')));
                        return;
                      } else if (telNumberParsed == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tienes que introducir solo números en el campo de teléfono')));
                        return;
                      } else if (telNumber.length < 8) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El numero de telefono es demasiado corto')));
                        return;
                      } else if (selectedDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tienes que seleccionar la fecha de tu nacimiento')));
                        return;
                      } else if (password.length < 8 || password2.length < 8) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tienes que introducir una contraseña')));
                        return;
                      } else if (password.isEmpty || password2.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La contraseña es demasiado corta')));
                        return;
                      } else if (password != password2) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Las contraseñas no coinciden')));
                        return;
                      }
                      context.read<UserBloc>().add(SignUpButtonPressed(email: email, password: password, name: name, surname: surname, telNumber: telNumberParsed, dateBirth: selectedDate!));
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 10, 185, 121),
                      minimumSize: const Size(double.infinity, 70), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "Crear usuario y iniciar sesion",
                      style: TextStyle(
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