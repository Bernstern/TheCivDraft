import 'package:flutter/material.dart';

// TODO: Add a theme for dark mode
// TODO: Do our icon and text themes properly
ThemeData theme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFFCFE8FF),
  primaryColorDark: const Color(0xFF2F4F4F),
  primaryColorLight: const Color(0xFFFFFFFF),
  primaryColor: Colors.white,
  highlightColor: const Color(0xFF800080),
  hintColor: const Color(0xFF228B22),
  iconTheme: iconTheme,
  fontFamily: 'Roboto',
);

IconThemeData iconTheme = const IconThemeData(
  color: Color(0xFFFFFFFF),
);

final largeTextStyle = TextStyle(
  fontSize: 24,
  color: theme.primaryColorLight,
);

final mediumTextStyle = TextStyle(fontSize: 18, color: theme.primaryColorLight);
