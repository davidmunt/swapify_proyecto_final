import 'package:flutter/material.dart';
import 'package:swapify/injection.dart';
import 'package:go_router/go_router.dart';
import 'package:swapify/presentation/screens/change_password_screen.dart';
import 'package:swapify/presentation/screens/change_user_avatar_screen.dart';
import 'package:swapify/presentation/screens/change_user_info_screen.dart';
import 'package:swapify/presentation/screens/config_and_privacy_screen.dart';
import 'package:swapify/presentation/screens/home_screen.dart';
import 'package:swapify/presentation/screens/login_screen.dart';
import 'package:swapify/domain/repositories/user_repository.dart';
import 'package:swapify/presentation/screens/create_acount_screen.dart';
import 'package:swapify/presentation/screens/profile_screen.dart';
import 'package:swapify/presentation/screens/reset_password_screen.dart';
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
      path: '/reset_password',
      builder: (BuildContext context, GoRouterState state) {
        return const ResetPasswordScreen();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/config_and_privacy',
      builder: (BuildContext context, GoRouterState state) {
        return const ConfigAndPrivacyScreen();
      },
    ),
    GoRoute(
      path: '/change_password',
      builder: (BuildContext context, GoRouterState state) {
        return const ChangePasswordScreen();
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (BuildContext context, GoRouterState state) {
        return const ProfileScreen();
      },
    ),
    GoRoute(
      path: '/change_user_info',
      builder: (BuildContext context, GoRouterState state) {
        return const ChangeUserInfoScreen();
      },
    ),
    GoRoute(
      path: '/change_user_avatar',
      builder: (BuildContext context, GoRouterState state) {
        return const ChangeUserAvatarScreen();
      },
    ),
  ],
  redirect: (context, state) async {
    try {
      final isLoggedIn = await sl<UserRepository>().isLoggedIn();
      return isLoggedIn.fold(
        (_) => '/login',
        (loggedIn) {
          final rutaccesosinlogg = ['/login', '/create_acount', '/reset_password'];
          if (loggedIn == "NO_USER" && !rutaccesosinlogg.contains(state.matchedLocation)) {
            return '/login';
          }
          return null;
        },
      );
    } catch (e) {
      return '/login';
    }
  },
);