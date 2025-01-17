import 'dart:ui';

class LanguageState {
  final Locale locale;
  final bool isLoading;

  LanguageState(this.locale, {this.isLoading = false});

  LanguageState copyWith({
    Locale? locale,
    bool? isLoading,
  }) {
    return LanguageState(
      locale ?? this.locale,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
