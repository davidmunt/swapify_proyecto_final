import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/entities/user.dart';
import 'package:swapify/domain/usecases/add_balance_to_user_usecase.dart';
import 'package:swapify/domain/usecases/add_rating_to_user_usecase.dart';
import 'package:swapify/domain/usecases/change_password_user_usecase.dart';
import 'package:swapify/domain/usecases/change_user_avatar_usecase.dart';
import 'package:swapify/domain/usecases/change_user_info_usecase.dart';
import 'package:swapify/domain/usecases/change_user_password_usecase.dart';
import 'package:swapify/domain/usecases/delete_user_usecase.dart';
import 'package:swapify/domain/usecases/get_current_user_usecase.dart';
import 'package:swapify/domain/usecases/get_user_info_usecase.dart';
import 'package:swapify/domain/usecases/get_users_info_usecase.dart';
import 'package:swapify/domain/usecases/login_to_get_token_from_backend_usecase.dart';
import 'package:swapify/domain/usecases/reset_password_user_usecase.dart';
import 'package:swapify/domain/usecases/save_user_info_usecase.dart';
import 'package:swapify/domain/usecases/save_user_notification_token_usecase.dart';
import 'package:swapify/domain/usecases/sign_in_user_usecase.dart';
import 'package:swapify/domain/usecases/sign_out_user_usecase.dart';
import 'package:swapify/domain/usecases/sign_up_user_usecase.dart';
import 'package:swapify/presentation/blocs/user/user_event.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final SigninUserUseCase signInUserUseCase;
  final SignUpUserUsecase signUpUserUsecase;
  final ResetPassUserUsecase resetPasswordUseCase;
  final ChangePassUserUsecase changePassUserUsecase;
  final ChangeUserPasswordUseCase changeUserPasswordUseCase;
  final ChangeUserInfoUseCase changeUserInfoUseCase;
  final GetUserInfoUseCase getUserInfoUseCase;
  final ChangeUserAvatarUseCase changeUserAvatarUseCase;
  final DeleteUserUseCase deleteUserUseCase;
  final SaveUserInfoUseCase saveUserInfoUseCase;
  final SignoutUserUseCase signOutUserUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final GetUsersInfoUseCase getUsersInfoUseCase;
  final SaveUserNotificationTokenUseCase saveUserNotificationTokenUseCase;
  final AddBalanceToUserUseCase addBalanceToUserUseCase;
  final AddRatingToUserUseCase addRatingToUserUseCase;
  final LoginToGetTokenFromBackendUseCase loginToGetTokenFromBackendUseCase;

  UserBloc(
    this.signInUserUseCase,
    this.signUpUserUsecase,
    this.signOutUserUseCase,
    this.getCurrentUserUseCase,
    this.saveUserInfoUseCase,
    this.resetPasswordUseCase,
    this.changeUserInfoUseCase,
    this.getUserInfoUseCase,
    this.changeUserAvatarUseCase,
    this.changePassUserUsecase,
    this.changeUserPasswordUseCase,
    this.deleteUserUseCase,
    this.getUsersInfoUseCase,
    this.saveUserNotificationTokenUseCase,
    this.addBalanceToUserUseCase,
    this.addRatingToUserUseCase,
    this.loginToGetTokenFromBackendUseCase,
  ) : super(UserState.initial()) {

    //inicia de sesion, obtiene su token y datos desde el backend
    on<LoginButtonPressed>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final loginResult = await signInUserUseCase(LoginParams(email: event.email, password: event.password));
      await loginResult.fold(
        (failure) async {
          emit(UserState.failure("Fallo al hacer el login"));
        },
        (user) async {
          final tokenResult = await loginToGetTokenFromBackendUseCase(LoginToGetTokenFromBackendParams(email: event.email, password: event.password));
          await tokenResult.fold(
            (failure) async {
              emit(UserState.failure("Fallo al obtener el token del backend"));
            },
            (token) async {
              try {
                final userInfo = await getUserInfoUseCase(GetUserInfoParams(uid: user.id, token: token));
                emit(state.copyWith(isLoading: false, user: userInfo, token: token));
              } catch (e) {
                emit(UserState.failure("Fallo al obtener la información del usuario: $e"));
              }
            },
          );
        },
      );
    });

    //verifica si hay un usuario actualmente autenticado en Firebase
    on<CheckAuthentication>((event, emit) async {
      final result = await getCurrentUserUseCase(NoParams());
      result.fold(
        (failure) => emit(UserState.failure("Fallo al verificar la autenticacion")),
        (username) {
          final user = UserEntity(email: username, id: "UNKNOWN_ID");
          emit(UserState.success(user));
        },
      );
    });

    //envia un correo para restablecer la contraseña del usuario
    on<ResetPasswordButtonPressed>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final result = await resetPasswordUseCase(ResetParams(email: event.email));
      result.fold(
        (failure) => emit(UserState.failure("Fallo al enviar el email para cambiar la contraseña")),
        (_) => emit(UserState.resetPasswordSuccess()),
      );
    });

    //elimina al usuario del Firebase y backend
    on<DeleteUserButtonPressed>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final token = state.token;
      if (token == null) {
        emit(UserState.failure("No hay token"));
        return;
      }
      final result = await deleteUserUseCase(DeleteUserParams(id: event.id, token: token));
      result.fold(
        (failure) => emit(UserState.failure("Fallo al eliminar el usuario")),
        (_) => emit(UserState.initial()),
      );
    });

    //modifica la informacion del usuario
    on<ChangeUserInfoButtonPressed>((event, emit) async {
      emit(state.copyWith(isLoading: true)); 
      final token = state.token;
      if (token == null) {
        emit(UserState.failure("No hay token"));
        return;
      }
      try {
        final result = await changeUserInfoUseCase(ChangeUserInfoParams(
          uid: event.uid,
          name: event.name,
          surname: event.surname,
          telNumber: event.telNumber,
          dateBirth: event.dateBirth,
          token: token,
        ));
        await result.fold(
          (failure) async {
            emit(state.copyWith(isLoading: false, errorMessage: "Error al cambiar la informacion del usuario"));
          },
          (_) async {
            try {
              final updatedUser = await getUserInfoUseCase(GetUserInfoParams(uid: event.uid, token: token));
              emit(state.copyWith(
                isLoading: false,
                user: updatedUser,
              ));
            } catch (e) {
              emit(state.copyWith(
                isLoading: false,
                errorMessage: "Error inesperado al obtener la informacion actualizada: $e",
              ));
            }
          },
        );
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: "Error inesperado: $e",
        ));
      }
    });

    //guarda el token de notificaciones del usuario en el backend
    on<SaveUserNotificationTokenButtonPressed>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final token = state.token;
      if (token == null) {
        emit(UserState.failure("No hay token"));
        return;
      }
      try {
        final result = await saveUserNotificationTokenUseCase(SaveUserNotificationTokenParams(
          userId: event.userId,
          notificationToken: event.notificationToken,
          token: token,
        ));
        await result.fold(
          (failure) async {
            emit(state.copyWith(
              isLoading: false,
              errorMessage: "Error al guardar el token de notificaciones del usuario",
            ));
          },
          (_) async {
            try {
              final updatedUser = await getUserInfoUseCase(GetUserInfoParams(uid: event.userId, token: token));
              emit(state.copyWith(
                isLoading: false,
                user: updatedUser,
              ));
            } catch (e) {
              emit(state.copyWith(
                isLoading: false,
                errorMessage: "Error al obtener la información actualizada: $e",
              ));
            }
          },
        );
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: "Error inesperado: $e",
        ));
      }
    });

    //registra un usuario nuevo
    on<SignUpButtonPressed>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final signUpResult = await signUpUserUsecase(SignUpParams(
        email: event.email,
        password: event.password,
      ));
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
              final saveUserInfoResult = await saveUserInfoUseCase(SaveUserInfoParams(
                uid: user.id,
                name: event.name,
                surname: event.surname,
                email: event.email,
                telNumber: event.telNumber,
                dateBirth: event.dateBirth,
                password: event.password,
              ));
              await saveUserInfoResult.fold(
                (failure) {
                  emit(UserState.failure("Fallo al guardar la informacion del usuario en el backend"));
                },
                (_) async {
                  final tokenResult = await loginToGetTokenFromBackendUseCase(LoginToGetTokenFromBackendParams(email: event.email, password: event.password));
                  await tokenResult.fold(
                    (failure) async {
                      emit(UserState.failure("Fallo al obtener el token del backend"));
                    },
                    (token) async {
                      try {
                        final userInfo = await getUserInfoUseCase(GetUserInfoParams(
                          uid: user.id,
                          token: token,
                        ));
                        emit(state.copyWith(isLoading: false, user: userInfo, token: token));
                      } catch (e) {
                        emit(UserState.failure("Error al buscar la informacion del usuario: $e"));
                      }
                    },
                  );
                },
              );
            },
          );
        },
      );
    });

    //obtiene la informacion de los usuarios
    on<GetUsersInfoButtonPressed>((event, emit) async {
      if (state.users != null && state.users!.isNotEmpty) {
        return;
      }
      emit(state.copyWith(isLoading: true));
      try {
        final token = state.token;
        if (token == null) {
          emit(UserState.failure("No hay token"));
          return;
        }
        final users = await getUsersInfoUseCase(GetUsersInfoParams(token: token));
        emit(state.copyWith(
          isLoading: false,
          users: users,
          user: state.user,
        ));
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: "Error al buscar la informacion de los usuarios: $e",
          user: state.user,
        ));
      }
    });

    //modifica la contraseña del usuario en Firebase y backend
    on<ChangePasswordButtonPressed>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final firebaseResult = await changePassUserUsecase(ChangeParams(password: event.password));
      await firebaseResult.fold(
        (failure) async {
          emit(UserState.failure("Error al cambiar la contraseña en Firebase"));
        },
        (_) async {
          final token = state.token;
          final userId = state.user?.id;
          if (token == null || userId == null) {
            emit(UserState.failure("Falta el token o el ID del usuario para cambiar la contraseña en el backend"));
            return;
          }
          final backendResult = await changeUserPasswordUseCase(ChangeUserPasswordParams(
            userId: userId,
            password: event.password,
            token: token,
          ));
          await backendResult.fold(
            (failure) async {
              emit(UserState.failure("Error al cambiar la contraseña en el backend"));
            },
            (_) async {
              emit(UserState.changePasswordSuccess());
            },
          );
        },
      );
    });

    //modifica el avatar de un usuario
    on<ChangeUserAvatarButtonPressed>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final result = await changeUserAvatarUseCase(ChangeUserAvatarParams(uid: event.uid, image: event.image));
        await result.fold(
          (failure) async {
            emit(UserState.failure("Error al cambiar el avatar del usuario"));
          },
          (_) async {
            try {
              final token = state.token;
              if (token == null) {
                emit(UserState.failure("No hay token"));
                return;
              }
              final updatedUser = await getUserInfoUseCase(GetUserInfoParams(uid: event.uid, token: token));
              emit(UserState.success(updatedUser));
            } catch (e) {
              emit(UserState.failure("Error al obtener el usuario actualizado: $e"));
            }
          },
        );
      } catch (e) {
        emit(UserState.failure("Error inesperado: $e"));
      }
    });

    //cierra la sesion de un usuario
    on<LogoutButtonPressed>((event, emit) async {
      final result = await signOutUserUseCase(NoParams());
      result.fold(
        (failure) => emit(UserState.failure("Fallo al realizar el logout")),
        (_) async {
          emit(UserState.initial());
        },
      );
    });

    //añade saldo al usuario
    on<AddBalanceToUserButtonPressed>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final token = state.token;
      if (token == null) {
        emit(UserState.failure("No hay token"));
        return;
      }
      try {
        final result = await addBalanceToUserUseCase(AddBalanceToUserParams(
          userId: event.userId,
          balanceToAdd: event.balanceToAdd,
          token: token,
        ));
        await result.fold(
          (failure) async {
            emit(state.copyWith(
              isLoading: false,
              errorMessage: "Error al añadir el saldo al usuario",
            ));
          },
          (_) async {
            try {
              final updatedUser = await getUserInfoUseCase(GetUserInfoParams(uid: event.userId, token: token));
              emit(state.copyWith(
                isLoading: false,
                user: updatedUser,
              ));
            } catch (e) {
              emit(state.copyWith(
                isLoading: false,
                errorMessage: "Error inesperado al obtener la informacion actualizada: $e",
              ));
            }
          },
        );
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: "Error inesperado: $e",
        ));
      }
    });

    //añade la valoracion a un usuario
    on<AddRatingToUserButtonPressed>((event, emit) async {
      try {
        final token = state.token;
        if (token == null) {
          emit(UserState.failure("No hay token"));
          return;
        }
        addRatingToUserUseCase(AddRatingToUserParams(
          userId: event.userId,
          customerId: event.customerId,
          productId: event.productId,
          rating: event.rating,
          token: token
        ));
      } catch (e) {
        emit(UserState.failure("Error inesperado: $e"));
      }
    });
  }
}