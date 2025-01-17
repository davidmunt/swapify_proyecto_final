import 'dart:ui';

abstract class LanguageEvent {}

class ChangeLanguageEvent extends LanguageEvent {
  final Locale locale;

  ChangeLanguageEvent(this.locale);
}