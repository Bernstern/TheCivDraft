import 'dart:developer';

import 'package:civgen/shared/helpers.dart';
import 'package:civgen/styles.dart';
import 'package:flutter/material.dart';

// The color of the chip when it is NOT pressed
Color defaultChipColor = theme.highlightColor;
Color defaultTextColor = theme.primaryColor;
List<BoxShadow> defaultBoxShadow = [
  const BoxShadow(color: Colors.black38, offset: Offset(4, 4), blurRadius: 15, spreadRadius: 1),
  BoxShadow(
      color: theme.highlightColor.withOpacity(.12), offset: const Offset(-4, -4), blurRadius: 15, spreadRadius: 1),
];

/// Chip that displays a nation icon and a leader name.
///
/// The nationIcon is the name of the image file in the images folder.
class NationChip extends StatelessWidget {
  final String leaderName;
  final String nationIcon;
  final Function onChipPressed;

  final bool chipIsHighlighted;
  final bool chipIsBanned;
  final bool chipIsPicked;

  const NationChip({
    super.key,
    required this.leaderName,
    required this.nationIcon,
    required this.onChipPressed,
    required this.chipIsHighlighted,
    required this.chipIsBanned,
    this.chipIsPicked = false,
  });

  @override
  Widget build(BuildContext context) {
    // log("Rendering chip for $leaderName (highlighted: $chipIsHighlighted)");
    Color chipColor = defaultChipColor;
    Color textColor = defaultTextColor;
    List<BoxShadow> boxShadow = defaultBoxShadow;

    // If the chip is locked or highlighted, it should be inactive
    if (chipIsHighlighted) {
      chipColor = theme.shadowColor;
      boxShadow = [];
    } else if (chipIsBanned) {
      chipColor = theme.disabledColor;
      textColor = const Color.fromARGB(255, 92, 92, 92);
      boxShadow = [];
    } else if (chipIsPicked) {
      chipColor = theme.hintColor;
      boxShadow = [];
    }

    return TextButton(
      onPressed: () => {!chipIsBanned ? onChipPressed() : log("Chip is locked!)}")},
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
              fetchIconForLeader(leaderName),
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
