import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapify/injection.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_event.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';

class ChangeUserAvatarScreen extends StatefulWidget {
  const ChangeUserAvatarScreen({super.key});

  @override
  State<ChangeUserAvatarScreen> createState() => ChangeUserAvatarScreenState();
}

class ChangeUserAvatarScreenState extends State<ChangeUserAvatarScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  Future<void> _selectImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modificar avatar del usuario"),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? "Ha habido un error")),
              );
            } else if (state.errorMessage == null && !state.isLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Avatar del usuario modificado")),
              );
              context.go('/home');
            }
          },
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 70),
                  TextButton(
                    onPressed: _selectImage,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 218, 218, 218),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Selecciona la imagen del avatar",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 10, 185, 121),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextButton(
                      onPressed: () {
                        if (_selectedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tienes que seleccionar una imagen')));
                          return;
                        }
                        final prefs = sl<SharedPreferences>();
                        final id = prefs.getString('id');
                        if (id != null) {
                          context.read<UserBloc>().add(
                            ChangeUserAvatarButtonPressed(uid: id, image: _selectedImage!),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se encontro el ID del usuario')));
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 10, 185, 121),
                        minimumSize: const Size(double.infinity, 70), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Guardar avatar del usuario",
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
              ),
            );
          },
        ),
      ),
    );
  }
}
