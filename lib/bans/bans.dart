import 'dart:developer';

import 'package:civgen/shared/chip.dart';
import 'package:civgen/shared/header.dart';
import 'package:civgen/shared/submit_button.dart';
import 'package:civgen/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:civgen/globals.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class BansPage extends StatefulWidget {
  const BansPage({super.key});

  @override
  State<BansPage> createState() => _BansPageState();
}

class _BansPageState extends State<BansPage> {
  @override
  Widget build(BuildContext context) {
    return BansText();
  }
}

class BansText extends StatefulWidget {
  const BansText({super.key});

  @override
  State<BansText> createState() => _BansTextState();
}

class _BansTextState extends State<BansText> {
  String highlightedCivLeaderName = "";
  Map<String, NationChip> civChips = {};
  List<String> bannedCivs = []; // Banned === locked

  // Represent if any chip is focused
  bool chipFocused = false;

  // Keep track of which chips are pressed
  void onChipPressed(String leaderName) {
    log("Toggling the ban for $leaderName, no longer highlighting $highlightedCivLeaderName");
    setState(() {
      // First update the previous highlighted chip
      if (highlightedCivLeaderName != "") {
        civChips[highlightedCivLeaderName] = generateNationChip(highlightedCivLeaderName, false, false);
      }

      highlightedCivLeaderName = leaderName;

      // Then update the new highlighted chip
      civChips[leaderName] = generateNationChip(leaderName, false, true);
    });
  }

  void onSubmitPressed() {
    // Update the highlighted chip to be locked
    civChips[highlightedCivLeaderName] = generateNationChip(highlightedCivLeaderName, true, false);

    // Add the highlighted civ to the list of banned civs
    bannedCivs.add(highlightedCivLeaderName);

    // Reset the highlighted civ
    highlightedCivLeaderName = "";
  }

  NationChip generateNationChip(String leaderName, [bool chipIsLocked = false, bool chipIsHighlighted = false]) {
    return NationChip(
        leaderName: leaderName,
        nationIcon: 'Icon_civilization_america.webp',
        onChipPressed: () => onChipPressed(leaderName),
        chipIsHighlighted: chipIsHighlighted,
        chipIsLocked: chipIsLocked);
  }

  @override
  Widget build(BuildContext context) {
    if (civChips.isEmpty) {
      log("DAB");
      for (var civ in civList) {
        String leaderName = civ["leaderName"];
        civChips[leaderName] = generateNationChip(leaderName);
      }
    }

    ResponsiveGridList grid = ResponsiveGridList(
      rowMainAxisAlignment: MainAxisAlignment.center,
      shrinkWrap: true,
      minItemWidth: 150,
      horizontalGridSpacing: 12,
      verticalGridSpacing: 12,
      children: civChips.values.toList(),
    );

    return MaterialApp(
      title: 'bans',
      home: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: headerBar("shit", "Banning phase", "cum"),
        body: Center(
          child: FractionallySizedBox(widthFactor: .6, child: grid),
        ),
        floatingActionButton: AnimatedFloatingSubmitButton(
          text: "Confirm Ban",
          onPressed: onSubmitPressed,
          opacityFunction: () => (highlightedCivLeaderName == "" ? 0.0 : 1.0),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
