import 'dart:developer';

import 'package:civgen/models.dart';
import 'package:civgen/shared/chip.dart';
import 'package:civgen/shared/header.dart';
import 'package:civgen/shared/submit_button.dart';
import 'package:civgen/shared/timer.dart';
import 'package:civgen/styles.dart';
import 'package:flutter/material.dart';
import 'package:civgen/globals.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class BansPage extends StatefulWidget {
  const BansPage({super.key});

  @override
  State<BansPage> createState() => _BansPageState();
}

class _BansPageState extends State<BansPage> {
  String? highlightedCivLeaderName;
  Map<String, NationChip> civChips = {};
  List<String> bannedCivs = []; // Banned === locked
  Map<int, String> playerNames = {};
  int activePlayer = 0;

  // Represent if any chip is focused
  bool chipFocused = false;

  // Timer in the header
  TimerWidget? timerWidget;

  // Init function
  @override
  void initState() {
    super.initState();

    log("First time building the bans page, generating all the chips...");
    for (var civ in civList) {
      String leaderName = civ["leaderName"];
      civChips[leaderName] = generateNationChip(leaderName);
    }
  }

  // Keep track of which chips are pressed
  void onChipPressed(String leaderName) {
    log("Toggling the ban for $leaderName, no longer highlighting $highlightedCivLeaderName");
    setState(() {
      // First update the previous highlighted chip
      if (highlightedCivLeaderName != null) {
        civChips[highlightedCivLeaderName!] = generateNationChip(highlightedCivLeaderName!, false, false);
      }

      highlightedCivLeaderName = leaderName;

      // Then update the new highlighted chip
      civChips[leaderName] = generateNationChip(leaderName, false, true);
    });
  }

  void onSubmitPressed() {
    if (highlightedCivLeaderName == null) {
      throw Exception("No civ is highlighted, submit button shouldn't be visible!");
    }

    // Update the highlighted chip to be locked
    setState(() {
      civChips[highlightedCivLeaderName!] = generateNationChip(highlightedCivLeaderName!, true, false);
    });

    // Add the highlighted civ to the list of banned civs
    bannedCivs.add(highlightedCivLeaderName!);
    highlightedCivLeaderName = null;

    advanceToNextPlayer();
  }

  NationChip generateNationChip(String leaderName, [bool chipIsLocked = false, bool chipIsHighlighted = false]) {
    return NationChip(
        leaderName: leaderName,
        nationIcon: 'Icon_civilization_america.webp',
        onChipPressed: () => onChipPressed(leaderName),
        chipIsHighlighted: chipIsHighlighted,
        chipIsLocked: chipIsLocked);
  }

  void resetTimer() {
    // TODO: Fetch the timer from the context and make it configurable
    timerWidget = TimerWidget(
        durationSeconds: 10,
        onTimerExpired: () {
          log("Timer expired, moving to the next player");
          advanceToNextPlayer();
        });
    log("Timer reset...");
  }

  void advanceToNextPlayer() {
    log("Advancing to the next player, current player: $activePlayer");

    // Reset the timer
    resetTimer();

    // Also bump to the next player
    setState(() {
      activePlayer = (activePlayer + 1) % playerNames.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If the player names is empty, get the number of players from the DraftConfiguration
    // TODO: move this setup to initState - you can't have context there though so you have to do some hacking with a future
    if (playerNames.isEmpty) {
      log("First time building the bans page, generating the player names...");

      int numPlayers = context.select<DraftConfiguration, int>((conf) => conf.setupPlayers.value);
      log("Number of players: $numPlayers");

      for (int i = 0; i < numPlayers; i++) {
        playerNames[i] = "Player ${i + 1}";
      }
    }

    // If the timer widget is null, create it
    if (timerWidget == null) {
      log("First time building the bans page, generating the timer widget...");
      resetTimer();
    }

    ResponsiveGridList grid = ResponsiveGridList(
      rowMainAxisAlignment: MainAxisAlignment.center,
      shrinkWrap: true,
      minItemWidth: 150,
      horizontalGridSpacing: 12,
      verticalGridSpacing: 12,
      children: civChips.values.toList(),
    );

    // TODO: Make banned chips disappear on transition to draft page
    return MaterialApp(
      title: 'bans',
      home: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: headerBar(playerNames[activePlayer]!, "Banning phase", timerWidget!),
        body: Center(
          child: FractionallySizedBox(widthFactor: .6, child: grid),
        ),
        floatingActionButton: AnimatedFloatingSubmitButton(
          text: "Confirm Ban",
          onPressed: onSubmitPressed,
          opacityFunction: () => (highlightedCivLeaderName == null ? 0.0 : 1.0),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
