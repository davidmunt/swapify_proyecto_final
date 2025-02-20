import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/presentation/blocs/navigation_bar/navigation_bar_event.dart';
import 'package:swapify/presentation/blocs/navigation_bar/navigation_bar_state.dart';

class NavigationBarBloc extends Bloc<NavigationBarEvent, NavigationBarState> {

  NavigationBarBloc() : super(NavigationBarState.initial()) {
    on<ChangeNavigationBarButtonPressed>((event, emit) async {
      emit(NavigationBarState.loading());
      try {
        emit(NavigationBarState.success(event.numNavigationBar));
      } catch (e) {
        emit(NavigationBarState.failure("Fallo al cambiar el numero del Navigation Bar: $e"));
      }
    });
  }
}
