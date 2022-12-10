import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
    backgroundColor: const Color(0xFFCFE8FF),
    primaryColorDark: const Color(0xFF2F4F4F),
    primaryColorLight: const Color(0xFFFFFFFF),
    highlightColor: const Color(0xFF800080),
    hintColor: const Color(0xFF228B22));

final largeTextStyle = TextStyle(
  fontSize: 24,
  color: theme.primaryColorLight,
);

final mediumTextStyle = TextStyle(
  fontSize: 18,
  color: theme.primaryColorLight,
);
