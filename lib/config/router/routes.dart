import 'package:flutter/material.dart';
import 'package:swapify/injection.dart';
import 'package:go_router/go_router.dart';
import 'package:swapify/presentation/screens/change_password_screen.dart';
import 'package:swapify/presentation/screens/change_user_avatar_screen.dart';
import 'package:swapify/presentation/screens/change_user_info_screen.dart';
import 'package:swapify/presentation/screens/chat_screen.dart';
import 'package:swapify/presentation/screens/config_and_privacy_screen.dart';
import 'package:swapify/presentation/screens/create_modify_product_screen.dart';
import 'package:swapify/presentation/screens/home_screen.dart';
import 'package:swapify/presentation/screens/login_screen.dart';
import 'package:swapify/domain/repositories/user_repository.dart';
import 'package:swapify/presentation/screens/create_acount_screen.dart';
import 'package:swapify/presentation/screens/product_screen.dart';
import 'package:swapify/presentation/screens/profile_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapify/presentation/screens/reset_password_screen.dart';
final GoRouter router = GoRouter(
  initialLocation: '/home',
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
    GoRoute(
      path: '/create_modify_product',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return CreateModifyProductScreen(
          productId: extra['productId'] as int?,
          marca: extra['marca'] as String?,
          modelo: extra['modelo'] as String?,
          descripcion: extra['descripcion'] as String?,
          precio: extra['precio'] as double?,
          categoria: extra['categoria'] as int?,
          estado: extra['estado'] as int?,
          images: extra['images'] as List<XFile>? ?? [],
        );
      },
    ),
    GoRoute(
      path: '/product',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return ProductScreen(
          id: extra['id'],
          marca: extra['marca'],
          modelo: extra['modelo'],
          descripcion: extra['descripcion'],
          precio: extra['precio'],
          categoria: extra['categoria'],
          estado: extra['estado'],
          fecha: extra['fecha'],
          userId: extra['userId'],
          latitudeCreated: extra['latitudeCreated'],
          longitudeCreated: extra['longitudeCreated'],
          nameCityCreated: extra['nameCityCreated'],
          images: List<String>.from(extra['images'] ?? []),
        );
      },
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        return ChatScreen(
          productOwnerId: extra['productOwnerId'],
          potBuyerId: extra['potBuyerId'],
          productId: extra['productId'],
        );
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