import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/usecases/get_current_user_usecase.dart';
import 'package:swapify/domain/usecases/reset_password_user_usecase.dart';

import 'package:swapify/domain/usecases/save_user_info_usecase.dart';
import 'package:swapify/domain/usecases/sign_in_user_usecase.dart';
import 'package:swapify/domain/usecases/sign_out_user_usecase.dart';
import 'package:swapify/domain/usecases/sign_up_user_usecase.dart';
import 'package:swapify/presentation/blocs/user/user_event.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final SigninUserUseCase signInUserUseCase;
  final SignUpUserUsecase signUpUserUsecase;
  final ResetPassUserUsecase resetPasswordUseCase;
  final SaveUserInfoUseCase saveUserInfoUseCase;
  final SignoutUserUseCase signOutUserUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  UserBloc(
    this.signInUserUseCase,
    this.signUpUserUsecase,
    this.signOutUserUseCase,
    this.getCurrentUserUseCase,
    this.saveUserInfoUseCase,
    this.resetPasswordUseCase,
  ) : super(UserState.initial()) {

    on<LoginButtonPressed>((event, emit) async {
      emit(UserState.loading());
      final result = await signInUserUseCase(LoginParams(email: event.email, password: event.password));
      result.fold(
        (failure) => emit(UserState.failure("Fallo al hacer el login")),
        (user) async {
        
          emit(UserState.success(user.email, user.id));
        },
      );
    });

    on<CheckAuthentication>((event, emit) async {
      final result = await getCurrentUserUseCase(NoParams());
      result.fold(
        (failure) => emit(UserState.failure("Fallo al verificar la autenticación")),
        (username) => emit(UserState.success(username)),
      );
    });

    on<ResetPasswordButtonPressed>((event, emit) async {
      emit(UserState.loading());
      final result = await resetPasswordUseCase(ResetParams(email: event.email));
      result.fold(
        (failure) => emit(UserState.failure("Fallo al resetear la contraseña")),
        (_) => emit(UserState.success("Correo de restablecimiento enviado")),
      );
    });

    on<SignUpButtonPressed>((event, emit) async {
      emit(UserState.loading());
      
      final signUpResult = await signUpUserUsecase(SignUpParams(email: event.email, password: event.password));
      await signUpResult.fold(
        (failure) {
          emit(UserState.failure("Fallo al crear el usuario"));
        },
        (_) async {
          final loginResult = await signInUserUseCase(LoginParams(email: event.email, password: event.password));
          await loginResult.fold(
            (failure) {
              emit(UserState.failure("Ya existe un usuario con ese email"));
            },
            (user) async {
              emit(UserState.success(user.email, user.id));
              final saveUserInfoResult = await saveUserInfoUseCase(SaveUserInfoParams(
                uid: user.id,
                name: event.name,
                surname: event.surname,
                email: event.email,
                telNumber: event.telNumber,
                dateBirth: event.dateBirth,
              ));
              saveUserInfoResult.fold(
                (failure) {
                  emit(UserState.failure("Fallo al guardar la informacion del usuario"));
                },
                (_) {
                  emit(UserState.success(user.email, user.id)); 
                },
              );
            },
          );
        },
      );
    });

    // on<SignUpButtonPressed>((event, emit) async {
    //   emit(UserState.loading());
    //   final result = await signUpUserUsecase(SignUpParams(email: event.email, password: event.password));
    //   await result.fold(
    //     (failure) {
    //       emit(UserState.failure("Fallo al crear el usuario"));
    //     },
    //     (_) async {
    //       final loginResult = await signInUserUseCase(LoginParams(email: event.email, password: event.password));
    //       loginResult.fold(
    //         (failure) {
    //           emit(UserState.failure("Ya exsiste un usuario con ese email"));
    //         },
    //         (user) {
    //           emit(UserState.success(user.email, user.id));
    //           //hacer el SaveUserInfoUseCase
    //         },
    //       );
    //     },
    //   );
    // });

    on<SaveUserInfoButtonPressed>((event, emit) async {
      emit(UserState.loading());
      final result = await saveUserInfoUseCase(SaveUserInfoParams(
        uid: event.uid,
        name: event.name,
        surname: event.surname,
        email: event.email,
        telNumber: event.telNumber,
        dateBirth: event.dateBirth,
      ));
      result.fold(
        (failure) => emit(UserState.failure("Fallo al guardar la información del usuario")),
        (_) => emit(UserState.success(event.email, event.uid)),
      );
    });

    on<LogoutButtonPressed>((event, emit) async {
      final result = await signOutUserUseCase(NoParams());
      result.fold(
        (failure) => emit(UserState.failure("Fallo al realizar el logout")),
        (_) async {
          emit(UserState.initial());
        },
      );
    });
  }
}