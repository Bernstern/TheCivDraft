import 'dart:developer';

import 'package:civgen/styles.dart';
import 'package:flutter/material.dart';

/// Chip that displays a nation icon and a leader name.
///
/// The nationIcon is the name of the image file in the images folder.
class NationChip extends StatelessWidget {
  final String leaderName;
  final String nationIcon;
  final Function onChipPressed;
  bool chipIsPressed;

  Color activeColor = theme.highlightColor;
  Color inactiveColor = Colors.black;

  Color activeText = theme.primaryColor;
  Color inactiveText = Colors.red;

  NationChip({
    super.key,
    required this.leaderName,
    required this.nationIcon,
    required this.onChipPressed,
    required this.chipIsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onChipPressed(),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(0),
      ),
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: chipIsPressed ? activeColor.withOpacity(.25) : activeColor),
              color: chipIsPressed ? inactiveColor : activeColor,
              boxShadow: chipIsPressed
                  ? []
                  : [
                      BoxShadow(color: Colors.black38, offset: Offset(4, 4), blurRadius: 15, spreadRadius: 1),
                      BoxShadow(
                          color: activeColor.withOpacity(.12), offset: Offset(-4, -4), blurRadius: 15, spreadRadius: 1),
                    ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'images/$nationIcon',
                width: 50,
                height: 50,
                color: chipIsPressed ? inactiveText : activeText,
              ),
              Text(
                leaderName,
                style: TextStyle(
                  color: chipIsPressed ? inactiveText : activeText,
                  fontSize: 18,
                ),
              )
            ],
          )),
    );
  }
}
