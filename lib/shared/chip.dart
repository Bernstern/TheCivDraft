import 'dart:developer';

import 'package:civgen/styles.dart';
import 'package:flutter/material.dart';

/// Chip that displays a nation icon and a leader name.
///
/// The nationIcon is the name of the image file in the images folder.
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
