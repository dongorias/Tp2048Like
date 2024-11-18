import 'package:flutter/material.dart';

String _fontFamily = "GoreRegular";

extension ThemeGetterExtension on BuildContext {
  ThemeData get themeData => Theme.of(this);

  TextTheme get textTheme => themeData.textTheme;

  ColorScheme get coloreSheme => themeData.colorScheme;

  Color get colorForeground => coloreSheme.onSurface;

  Color get colorAccent => const Color(0xff7C77B2);

  TextStyle get _text => textTheme.bodyMedium!;

  TextStyle get textTitle => _text.copyWith(
      fontSize: 24, fontWeight: FontWeight.w500, fontFamily: _fontFamily);

  TextStyle get textButton => _text.copyWith(
      fontSize: 15, fontWeight: FontWeight.w500, fontFamily: _fontFamily);

  TextStyle get textBody => _text.copyWith(
      fontSize: 15, fontWeight: FontWeight.w400, fontFamily: _fontFamily);

  TextStyle get textCaption => _text.copyWith(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      fontFamily: _fontFamily,
      color: Colors.white);
}
