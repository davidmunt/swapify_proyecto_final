import 'package:swapify/presentation/blocs/language/language_bloc.dart';
import 'package:swapify/presentation/blocs/language/language_event.dart';
import 'package:swapify/presentation/blocs/language/language_state.dart';
import 'package:swapify/presentation/blocs/product/product_bloc.dart';
import 'package:swapify/presentation/blocs/product_category/product_category_bloc.dart';
import 'package:swapify/presentation/blocs/product_sale_state/product_sale_state_bloc.dart';
import 'package:swapify/presentation/blocs/product_state/product_state_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:swapify/presentation/blocs/user/user_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  final language = prefs.getString('language');
  FlutterNativeSplash.remove();
  runApp(MyApp(email: email, password: password, id: id, language: language));
}

class MyApp extends StatelessWidget {
  final String? email;
  final String? password;
  final String? id;
  final String? language;
  const MyApp({super.key, this.email, this.password, this.id, this.language});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<UserBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<ProductCategoryBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<ProductStateBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<ProductSaleStateBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<ProductBloc>(),
        ),
        BlocProvider(
          create: (_) {
            final LanguageBloc languageBloc = sl<LanguageBloc>();
            if (language != null) {
              languageBloc.add(ChangeLanguageEvent(Locale(language!)));
            } else {
              languageBloc.add(ChangeLanguageEvent(const Locale('es')));
            }
            return languageBloc;
          },
        ),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) {
          if (email != null && password != null) {
            context.read<UserBloc>().add(LoginButtonPressed(email: email!, password: password!));
          }
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            title: 'Swapify',
            locale: languageState.locale,
            supportedLocales: const [
              Locale('en'),
              Locale('es'),
              Locale('fr'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: AppTheme(selectedColor: 9).getTheme(),
          );
        },
      ),
    );
  }
}
