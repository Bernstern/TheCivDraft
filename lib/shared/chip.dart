import 'dart:developer';

import 'package:civgen/styles.dart';
import 'package:flutter/material.dart';

Widget nationChip(String leaderName, String nationIcon) {
  return TextButton(
    onPressed: () => log('pressed'),
    style: TextButton.styleFrom(
      padding: const EdgeInsets.all(0),
    ),
    child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: theme.highlightColor),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'images/$nationIcon',
              width: 50,
              height: 50,
            ),
            Text(leaderName, style: mediumTextStyle),
          ],
        )),
  );
}
