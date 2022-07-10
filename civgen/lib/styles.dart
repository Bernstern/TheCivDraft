import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  cardColor: const Color.fromRGBO(0x04, 0x04, 0x03, 1), // Black
  shadowColor: const Color.fromRGBO(0xC3, 0xE8, 0xBD, 1), // Light Green
  backgroundColor: const Color.fromRGBO(0x22, 0x38, 0x43, 0.5), // Gunmetal
  primaryColor: const Color.fromRGBO(0x5B, 0x75, 0x53, 1), // Green
  errorColor: const Color.fromRGBO(0xF5, 0xEE, 0x9E, 1), // Green Yellow
);

final largeTextStyle = TextStyle(
  fontSize: 24,
  color: theme.primaryColor,
);

final mediumTextStyle = TextStyle(
  fontSize: 18,
  color: theme.primaryColor,
);

final buttonStyle = ElevatedButton.styleFrom(primary: theme.cardColor);
