import 'package:flutter/material.dart';
import 'package:swapify/injection.dart';
import 'package:go_router/go_router.dart';
import 'package:swapify/presentation/screens/home_screen.dart';
import 'package:swapify/presentation/screens/login_screen.dart';
import 'package:swapify/domain/repositories/user_repository.dart';
import 'package:swapify/presentation/screens/create_acount_screen.dart';
import 'package:swapify/presentation/screens/recover_password_screen.dart';
final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/create_acount',
      builder: (BuildContext context, GoRouterState state) {
        return const CreateAcountScreen();
      },
    ),
    GoRoute(
      path: '/recover_password',
      builder: (BuildContext context, GoRouterState state) {
        return const RecoverPasswordScreen();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
  ],
  // redirect: (context, state) async {
  //   try {
  //     final isLoggedIn = await sl<UserRepository>().isLoggedIn();
  //     return isLoggedIn.fold(
  //       (_) => '/login',
  //       (loggedIn) => loggedIn == "NO_USER" && !state.matchedLocation.contains("/login") ? "/login" : null,
  //     );
  //   } catch (e) {
  //     print('Error in redirect: $e');
  //     return '/login';
  //   }
  // },

  redirect: (context, state) async {
    try {
      final isLoggedIn = await sl<UserRepository>().isLoggedIn();
      return isLoggedIn.fold(
        (_) => '/login',
        (loggedIn) {
          final rutaccesosinlogg = ['/login', '/create_acount', '/recover_password'];
          if (loggedIn == "NO_USER" && !rutaccesosinlogg.contains(state.matchedLocation)) {
            return '/login';
          }
          return null;
        },
      );
    } catch (e) {
      print('Error in redirect: $e');
      return '/login';
    }
  },

);