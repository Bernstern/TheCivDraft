import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  cardColor: const Color.fromRGBO(0x21, 0x93, 0xbc, 1),
  unselectedWidgetColor: const Color.fromRGBO(0x8e, 0xca, 0xe6, 1),
  primaryColor: const Color.fromRGBO(0x02, 0x30, 0x47, 1),
  focusColor: const Color.fromRGBO(0xFB, 0x85, 0x00, 1),
  disabledColor: const Color.fromRGBO(0xFF, 0xB7, 0x03, 1),
);

final largeTextStyle = TextStyle(
  fontSize: 24,
  color: theme.primaryColor,
);

final mediumTextStyle = TextStyle(
  fontSize: 18,
  color: theme.primaryColor,
);

final mediumStrikeThroughStyle = TextStyle(
  fontSize: 18,
  decoration: TextDecoration.lineThrough,
  color: theme.primaryColor,
);

const mediumCopyStyle = TextStyle(
  fontSize: 18,
);

final ButtonStyle buttonStyle = ElevatedButton.styleFrom(primary: theme.cardColor);
final ButtonStyle bannedStyle = ElevatedButton.styleFrom(primary: theme.cardColor.withOpacity(0.2));
