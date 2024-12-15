import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:swapify/injection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/config/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:swapify/config/router/routes.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureDependencies();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<UserBloc>(),
        ),
        // BlocProvider(
        //   create: (_) => sl<TweetBloc>(),
        // ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        title: 'Swapify',
        theme: AppTheme(selectedColor: 9).getTheme(),
      ),
    );
  }
}
