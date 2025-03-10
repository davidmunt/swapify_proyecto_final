import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/entities/user.dart';
import 'package:swapify/domain/usecases/add_balance_to_user_usecase.dart';
import 'package:swapify/domain/usecases/add_rating_to_user_usecase.dart';
import 'package:swapify/domain/usecases/change_password_user_usecase.dart';
import 'package:swapify/domain/usecases/change_user_avatar_usecase.dart';
import 'package:swapify/domain/usecases/change_user_info_usecase.dart';
import 'package:swapify/domain/usecases/delete_user_usecase.dart';
import 'package:swapify/domain/usecases/get_current_user_usecase.dart';
import 'package:swapify/domain/usecases/get_user_info_usecase.dart';
import 'package:swapify/domain/usecases/get_users_info_usecase.dart';
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
    this.deleteUserUseCase,
    this.getUsersInfoUseCase,
    this.saveUserNotificationTokenUseCase,
    this.addBalanceToUserUseCase,
    this.addRatingToUserUseCase,
  ) : super(UserState.initial()) {

    on<LoginButtonPressed>((event, emit) async {
      emit(UserState.loading());
      final result = await signInUserUseCase(LoginParams(email: event.email, password: event.password));
      await result.fold(
        (failure) async {
          emit(UserState.failure("Fallo al hacer el login"));
        },
        (user) async {
          try {
            final userInfo = await getUserInfoUseCase(GetUserInfoParams(uid: user.id));
            emit(UserState.success(userInfo));
          } catch (e) {
            emit(UserState.failure("Fallo al obtener la informacion del usuario: $e"));
          }
        },
      );
    });

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

    on<ResetPasswordButtonPressed>((event, emit) async {
      emit(UserState.loading());
      final result = await resetPasswordUseCase(ResetParams(email: event.email));
      result.fold(
        (failure) => emit(UserState.failure("Fallo al enviar el email para cambiar la contraseña")),
        (_) => emit(UserState.resetPasswordSuccess()),
      );
    });

    on<DeleteUserButtonPressed>((event, emit) async {
      emit(UserState.loading());
      final result = await deleteUserUseCase(DeleteUserParams(id: event.id));
      result.fold(
        (failure) => emit(UserState.failure("Fallo al eliminar el usuario")),
        (_) => emit(UserState.initial()),
      );
    });

    on<ChangeUserInfoButtonPressed>((event, emit) async {
      emit(UserState.loading());
      try {
        final result = await changeUserInfoUseCase(ChangeUserInfoParams(
          uid: event.uid,
          name: event.name,
          surname: event.surname,
          telNumber: event.telNumber,
          dateBirth: event.dateBirth,
        ));
        await result.fold(
          (failure) async {
            emit(UserState.failure("Error al cambiar la informacion del usuario"));
          },
          (_) async {
            try {
              final updatedUser = await getUserInfoUseCase(GetUserInfoParams(uid: event.uid));
              emit(UserState.success(updatedUser));
            } catch (e) {
              emit(UserState.failure("Error inesperado al obtener la informacion actualizada: $e"));
            }
          },
        );
      } catch (e) {
        emit(UserState.failure("Error inesperado: $e"));
      }
    });

    on<SaveUserNotificationTokenButtonPressed>((event, emit) async {
      emit(UserState.loading());
      try {
        final result = await saveUserNotificationTokenUseCase(SaveUserNotificationTokenParams(
          userId: event.userId,
          notificationToken: event.notificationToken,
        ));
        await result.fold(
          (failure) async {
            emit(UserState.failure("Error al cambiar la informacion del usuario"));
          },
          (_) async {
            try {
              final updatedUser = await getUserInfoUseCase(GetUserInfoParams(uid: event.userId));
              emit(UserState.success(updatedUser));
            } catch (e) {
              emit(UserState.failure("Error inesperado al obtener la informacion actualizada: $e"));
            }
          },
        );
      } catch (e) {
        emit(UserState.failure("Error inesperado: $e"));
      }
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
              final saveUserInfoResult = await saveUserInfoUseCase(SaveUserInfoParams(
                uid: user.id,
                name: event.name,
                surname: event.surname,
                email: event.email,
                telNumber: event.telNumber,
                dateBirth: event.dateBirth,
              ));
              await saveUserInfoResult.fold(
                (failure) {
                  emit(UserState.failure("Fallo al guardar la informacion"));
                },
                (_) async {
                  try {
                    final userInfo = await getUserInfoUseCase(GetUserInfoParams(uid: user.id));
                    emit(UserState.success(userInfo));
                  } catch (e) {
                    emit(UserState.failure("Error al buscar la informacion del usuario: $e"));
                  }
                },
              );
            },
          );
        },
      );
    });

    on<GetUsersInfoButtonPressed>((event, emit) async {
      if (state.users != null && state.users!.isNotEmpty) {
        return;
      }
      emit(state.copyWith(isLoading: true));
      try {
        final users = await getUsersInfoUseCase(NoParams());
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

    on<ChangePasswordButtonPressed>((event, emit) async {
      emit(UserState.loading());
      final result = await changePassUserUsecase(ChangeParams(password: event.password));
      result.fold(
        (failure) => emit(UserState.failure("Error al cambiar la contraseña")),
        (_) => emit(UserState.changePasswordSuccess()),
      );
    });

    on<ChangeUserAvatarButtonPressed>((event, emit) async {
      emit(UserState.loading());
      try {
        final result = await changeUserAvatarUseCase(ChangeUserAvatarParams(uid: event.uid, image: event.image));
        await result.fold(
          (failure) async {
            emit(UserState.failure("Error al cambiar el avatar del usuario"));
          },
          (_) async {
            try {
              final updatedUser = await getUserInfoUseCase(GetUserInfoParams(uid: event.uid));
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

    on<LogoutButtonPressed>((event, emit) async {
      final result = await signOutUserUseCase(NoParams());
      result.fold(
        (failure) => emit(UserState.failure("Fallo al realizar el logout")),
        (_) async {
          emit(UserState.initial());
        },
      );
    });

    on<AddBalanceToUserButtonPressed>((event, emit) async {
      emit(UserState.loading());
      try {
        final result = await addBalanceToUserUseCase(AddBalanceToUserParams(
          userId: event.userId,
          balanceToAdd: event.balanceToAdd,
        ));
        await result.fold(
          (failure) async {
            emit(UserState.failure("Error al añadir el saldo al usuario"));
          },
          (_) async {
            try {
              final updatedUser = await getUserInfoUseCase(GetUserInfoParams(uid: event.userId));
              emit(UserState.success(updatedUser));
            } catch (e) {
              emit(UserState.failure("Error inesperado al obtener la informacion actualizada: $e"));
            }
          },
        );
      } catch (e) {
        emit(UserState.failure("Error inesperado: $e"));
      }
    });

    on<AddRatingToUserButtonPressed>((event, emit) async {
      try {
        addRatingToUserUseCase(AddRatingToUserParams(
          userId: event.userId,
          customerId: event.customerId,
          productId: event.productId,
          rating: event.rating,
        ));
      } catch (e) {
        emit(UserState.failure("Error inesperado: $e"));
      }
    });
  }
}