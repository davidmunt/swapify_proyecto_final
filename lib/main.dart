import 'package:swapify/presentation/blocs/user/user_event.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:swapify/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/config/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:swapify/config/router/routes.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies();
  final prefs = sl<SharedPreferences>();
  final email = prefs.getString('email');
  final password = prefs.getString('password');
  final id = prefs.getString('id');
  FlutterNativeSplash.remove();
  runApp(MyApp(email: email, password: password, id: id));
}

class MyApp extends StatelessWidget {
  final String? email;
  final String? password;
  final String? id;
  const MyApp({super.key, this.email, this.password, this.id});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<UserBloc>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          if (email != null && password != null) {
            context.read<UserBloc>().add(LoginButtonPressed(email: email!, password: password!));
          }
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            title: 'Swapify',
            theme: AppTheme(selectedColor: 9).getTheme(),
          );
        },
      ),
    );
  }
}
