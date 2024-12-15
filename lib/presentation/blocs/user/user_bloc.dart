import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/usecases/get_current_user_usecase.dart';
import 'package:swapify/domain/usecases/sign_in_user_usecase.dart';
import 'package:swapify/domain/usecases/sign_out_user_usecase.dart';
import 'package:swapify/presentation/blocs/user/user_event.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final SigninUserUseCase signInUserUseCase;
  final SignoutUserUseCase signOutUserUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  UserBloc(this.signInUserUseCase, this.signOutUserUseCase, this.getCurrentUserUseCase) : super(UserState.initial()) {

    on<LoginButtonPressed>((event, emit) async {
      emit(UserState.loading());
      final result = await signInUserUseCase(LoginParams(email: event.email, password: event.password));
      result.fold(
        (failure) => emit(UserState.failure("Fallo al hacer el login")),
        (user) => emit(UserState.success(user.email)),
      );
    });

    on<CheckAuthentication>((event, emit) async {
      final result = await getCurrentUserUseCase(NoParams());
      result.fold(
        (failure) =>
        emit(UserState.failure("Fallo al verificar la autenticación")),
        (username) => emit(UserState.success(username)),
      );
    });

    on<LogoutButtonPressed>((event, emit) async {
      final result = await signOutUserUseCase(NoParams());
      result.fold(
        (failure) => emit(UserState.failure("Fallo al realizar el logout")),
        (_) => emit(UserState.initial()));
    });
  }
}