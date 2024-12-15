import 'package:swapify/data/datasources/user_remote_datasource.dart';
import 'package:swapify/data/repositories/user_repository_impl.dart';
import 'package:swapify/domain/repositories/user_repository.dart';
import 'package:swapify/domain/usecases/get_current_user_usecase.dart';
import 'package:swapify/domain/usecases/sign_in_user_usecase.dart';
import 'package:swapify/domain/usecases/sign_out_user_usecase.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

void configureDependencies() {
  // BLocs
  sl.registerFactory<UserBloc>(
    () => UserBloc(sl(), sl(), sl()),
  );

  // Instancia de Firebase Auth
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Fuentes de datos
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(auth: sl<FirebaseAuth>()),
  );

  // Repositorios
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<FirebaseAuthDataSource>()),
  );

  // Casos de uso
  sl.registerLazySingleton<SigninUserUseCase>(
    () => SigninUserUseCase(sl()),
  );
  sl.registerLazySingleton<SignoutUserUseCase>(
    () => SignoutUserUseCase(sl()),
  );
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl()),
  );
}