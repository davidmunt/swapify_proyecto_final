import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapify/presentation/blocs/language/language_event.dart';
import 'package:swapify/presentation/blocs/language/language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState(const Locale('es'))) {
    on<ChangeLanguageEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', event.locale.languageCode);
      emit(LanguageState(event.locale, isLoading: false));
    });
  }
}
