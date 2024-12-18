import 'package:swapify/data/datasources/user_remote_datasource.dart';
import 'package:swapify/data/repositories/user_repository_impl.dart';
import 'package:swapify/domain/repositories/user_repository.dart';
import 'package:swapify/domain/usecases/get_current_user_usecase.dart';
import 'package:swapify/domain/usecases/reset_password_user_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swapify/domain/usecases/save_user_info_usecase.dart';
import 'package:swapify/domain/usecases/sign_in_user_usecase.dart';
import 'package:swapify/domain/usecases/sign_out_user_usecase.dart';
import 'package:swapify/domain/usecases/sign_up_user_usecase.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // BLocs
  sl.registerFactory<UserBloc>(
    () => UserBloc(sl(), sl(), sl(), sl(), sl(), sl()),
  );

  // Instancia de Firebase Auth
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Instancia de Firestore
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Fuentes de datos
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(
      auth: sl<FirebaseAuth>(), 
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  // Repositorios
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<FirebaseAuthDataSource>(), sl<SharedPreferences>()),
  );

  // Casos de uso
  sl.registerLazySingleton<SigninUserUseCase>(
    () => SigninUserUseCase(sl()),
  );
  sl.registerLazySingleton<SignUpUserUsecase>(
    () => SignUpUserUsecase(sl()),
  );
  sl.registerLazySingleton<SignoutUserUseCase>(
    () => SignoutUserUseCase(sl()),
  );
  sl.registerLazySingleton<ResetPassUserUsecase>(
    () => ResetPassUserUsecase(sl()),
  );
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl()),
  );
  sl.registerLazySingleton<SaveUserInfoUseCase>(
    () => SaveUserInfoUseCase(sl()),
  );
}