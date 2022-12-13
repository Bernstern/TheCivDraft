import 'package:civgen/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

AppBar headerBar(String leftText, String centerText, String rightText) {
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
          Text(rightText),
        ],
      ),
    ),
  );
}
