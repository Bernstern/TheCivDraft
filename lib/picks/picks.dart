// Placeholder page

import 'dart:developer';

import 'package:civgen/globals.dart';
import 'package:civgen/models.dart';
import 'package:civgen/picks/results.dart';
import 'package:civgen/shared/grid.dart';
import 'package:civgen/shared/header.dart';
import 'package:civgen/shared/popup.dart';
import 'package:civgen/shared/snake.dart';
import 'package:civgen/shared/submit_button.dart';
import 'package:civgen/shared/timer.dart';
import 'package:civgen/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PicksPage extends StatefulWidget {
  const PicksPage({Key? key}) : super(key: key);

  @override
  _PicksPageState createState() => _PicksPageState();
}

class _PicksPageState extends State<PicksPage> {
  String? highlightedCivLeaderName;
  Map<String, CivStatus> civStatus = {};
  Map<int, Map<int, String>> results = {};
  Map<int, String> playerNames = {};

  late SnakeDraft snakeDraft;

  late int numGames;
  TimerWidget? timerWidget;

  @override
  void initState() {
    super.initState();

    showPopup();
  }

  // TODO: If you run out of time you get a random civ
  void resetTimer() {
    // TODO: Fetch the timer from the context and make it configurable
    setState(() {
      timerWidget = TimerWidget(
          durationSeconds: 150,
          onTimerExpired: () {
            log("Timer expired, picking a random civ for ${snakeDraft.activeGame}");

            // Highlight a random available civ and "press the submit button"
            List<MapEntry<String, CivStatus>> availableCivs =
                civStatus.entries.where((element) => element.value == CivStatus.available).toList();

            // Throw an exception if there are no available civs
            if (availableCivs.isEmpty) {
              throw Exception("No available civs to pick!");
            }

            availableCivs.shuffle();
            MapEntry<String, CivStatus> randomCiv = availableCivs.first;
            highlightedCivLeaderName = randomCiv.key;
            onSubmitPressed();
            log("Random civ is $highlightedCivLeaderName");
          });
    });
    log("Timer reset...");
  }

  void onChipPressed(String leaderName) {
    log("Toggling selection for pick for $leaderName, no longer selecting $highlightedCivLeaderName");

    setState(() {
      // First update the previous highlighted chip
      if (highlightedCivLeaderName != null) {
        civStatus[highlightedCivLeaderName!] = CivStatus.available;
      }

      // Then update the new highlighted chip
      highlightedCivLeaderName = leaderName;
      civStatus[leaderName] = CivStatus.selected;
    });
  }

  // TODO: This is basically the same as the bans page, refactor
  void onSubmitPressed() {
    // Advance calls set state so we don't need to call it here
    if (highlightedCivLeaderName == null) {
      throw Exception("No civ selected, can't submit");
    }

    // Update it to be picked!
    log("Setting $highlightedCivLeaderName to be picked!");
    civStatus[highlightedCivLeaderName!] = CivStatus.picked;

    // Include this pick in the results - TODO: refactor this
    if (results[snakeDraft.activeGame] == null) {
      results[snakeDraft.activeGame] = {};
    }
    results[snakeDraft.activeGame]![snakeDraft.activePlayer] = highlightedCivLeaderName!;

    highlightedCivLeaderName = null;
    advanceToNextPlayer();
  }

  void advanceToNextPlayer() {
    log("Advancing to the next player...");

    // Reset the timer for the next player
    resetTimer();

    // Update the active player to the next one
    setState(() {
      snakeDraft.advance();
    });
  }

  void showPopup() async {
    log("Showing the picks popup...");
    await Future.delayed(Duration.zero);
    showDialog(
      context: context,
      builder: (context) => PopUp(
        title: "The Draft",
        content:
            "This draft is for $numGames games and each player will get two and a half minutes to pick each civ.\nThe draft style is a reverse snake with the lowest seeded player going first.\n\nNote that if you run out of time you will be given a random civ!",
        actionMessage: "Start the draft!",
        action: resetTimer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (playerNames.isEmpty) {
      log("First time building the picks page, generating the player names...");

      int numPlayers = context.select<DraftConfiguration, int>((conf) => conf.setupPlayers.value);
      log("Number of players: $numPlayers");

      for (int i = 0; i < numPlayers; i++) {
        playerNames[i] = "Player ${i + 1}";
      }

      numGames = context.select<DraftConfiguration, int>((conf) => conf.setupGames.value);
      log("Each player can pick $numGames civs");

      snakeDraft = SnakeDraft(numPlayers, numGames);
      log("Picks player order: $snakeDraft");
    }

    if (civStatus.isEmpty) {
      log("First time building the picks page, generating all the chips...");
      civMap.forEach((key, _) {
        civStatus[key] = CivStatus.available;
      });

      // Then go through to see if any civs are banned
      List<String> bannedCivs = context.select<DraftConfiguration, List<String>>((conf) => conf.bannedCivs);
      for (var civ in bannedCivs) {
        civStatus[civ] = CivStatus.banned;
      }
    }

    var width = MediaQuery.of(context).size.width;
    log("Results: $results");

    // Determine whether or not to show the grid
    Widget civGrid = Container();
    if (!snakeDraft.isDone) {
      civGrid = CivGrid(civStatuses: civStatus, onChipPressed: onChipPressed);
    }

    // Determine whether or not to show the active player
    String headerLeftText = "";
    if (!snakeDraft.isDone) {
      headerLeftText = "Game ${snakeDraft.activeGame + 1}:  ${playerNames[snakeDraft.activePlayer]!}";
    }

    // If we are done stop the timer
    // TODO: This is a bit hacky, refactor
    if (snakeDraft.isDone) {
      log("Stopping the timer...");
      timerWidget = null;
    }

    // Are we showing just the picks, the picks and the results, or just the results
    List<Widget> content = [];
    Widget generatePicksComponent() => SizedBox(width: width * 0.6, child: civGrid);
    Widget generateResultsComponent() => SizedBox(width: width * 0.3, child: ResultsTable(results: results));

    if (results.isEmpty) {
      log("No results yet, just showing the picks");
      content = [generatePicksComponent()];
    } else if (snakeDraft.isDone) {
      log("All results are in, just showing the results");
      content = [generateResultsComponent()];
    } else {
      log("Some results are in, showing the picks and the results");
      content = [generatePicksComponent(), generateResultsComponent()];
    }

    return MaterialApp(
      title: 'Picks',
      home: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: headerBar(headerLeftText, "Picks Phase", timerWidget),
        body: Center(child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [...content])),
        floatingActionButton: AnimatedFloatingSubmitButton(
          text: "Confirm Pick",
          onPressed: onSubmitPressed,
          opacityFunction: () => (highlightedCivLeaderName == null ? 0.0 : 1.0),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
