import 'package:civgen/shared/timer.dart';
import 'package:civgen/styles.dart';
import 'package:flutter/material.dart';

AppBar headerBar(String leftText, String centerText, TimerWidget? timer) {
  return AppBar(
    backgroundColor: theme.primaryColorDark,
    title: Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Text(leftText),
          const Spacer(),
          Text(centerText),
          const Spacer(),
          if (timer != null) timer,
        ],
      ),
    ),
  );
}
