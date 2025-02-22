import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swapify/injection.dart';
import 'package:flutter/foundation.dart';
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
  XFile? selectedImage;

  Future<void> _selectImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.changeUserAvatar),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage ?? AppLocalizations.of(context)!.error)));
            } else if (state.errorMessage == null && !state.isLoading) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.userAvatarChanged)));
              context.push('/home');
            }
          },
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  if (selectedImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: kIsWeb
                          ? Image.network(
                              selectedImage!.path, 
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(selectedImage!.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    )
                  else
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, size: 50, color: Colors.grey[700]),
                    ),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: _selectImage,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 218, 218, 218),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.selectImageUserAvatar,
                      style: const TextStyle(
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
                        if (selectedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorImageUserAvatarRequired)));
                          return;
                        }
                        final prefs = sl<SharedPreferences>();
                        final id = prefs.getString('id');
                        if (id != null) {
                          context.read<UserBloc>().add(ChangeUserAvatarButtonPressed(uid: id, image: selectedImage!));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorUserIdNotFount)));
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 10, 185, 121),
                        minimumSize: const Size(double.infinity, 70),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.saveUserAvatar,
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
              ),
            );
          },
        ),
      ),
    );
  }
}
