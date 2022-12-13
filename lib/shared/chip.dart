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

  bool chipIsHighlighted;
  bool chipIsLocked;

  NationChip({
    super.key,
    required this.leaderName,
    required this.nationIcon,
    required this.onChipPressed,
    required this.chipIsHighlighted,
    required this.chipIsLocked,
  });

  // The color of the chip when it is NOT pressed
  Color chipColor = theme.highlightColor;
  Color textColor = theme.primaryColor;
  List<BoxShadow> boxShadow = [
    const BoxShadow(color: Colors.black38, offset: Offset(4, 4), blurRadius: 15, spreadRadius: 1),
    BoxShadow(
        color: theme.highlightColor.withOpacity(.12), offset: const Offset(-4, -4), blurRadius: 15, spreadRadius: 1),
  ];

  @override
  Widget build(BuildContext context) {
    log("Rendering chip for $leaderName (highlighted: $chipIsHighlighted");

    // If the chip is locked or highlighted, it should be inactive
    if (chipIsHighlighted) {
      chipColor = theme.shadowColor;
      // textColor = Colors.red;
      boxShadow = [];
    } else if (chipIsLocked) {
      chipColor = theme.disabledColor;
      textColor = Color.fromARGB(255, 92, 92, 92);
      boxShadow = [];
    }

    return TextButton(
      onPressed: () => {!chipIsLocked ? onChipPressed() : log("Chip is locked!)}")},
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(0),
      ),
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(1), color: chipColor, boxShadow: boxShadow),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('images/$nationIcon', width: 40, height: 40, color: textColor),
              Flexible(
                child: Text(
                  leaderName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: textColor, fontSize: 18),
                ),
              )
            ],
          )),
    );
  }
}
