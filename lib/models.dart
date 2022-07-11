import 'dart:collection';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'globals.dart' as globals;

class DraftConfiguration extends ChangeNotifier {
  // TODO: Check if there are enough civs left to draft the number of players when banning

  DraftConfiguration({required this.numPlayers, required this.numCivs});

  int numPlayers;
  int numCivs;

  // Keep track of the indices of banned civs in the current configuration
  HashSet<int> bannedCivs = HashSet<int>();

  // Store results of the draft in a list of of lists of indices of civs
  List<List<int>> draftResults = [];

  // Store the chosen civs in the draft as a map of player number to picked civ index
  Map<int, int> draftChoices = {};

  // Setters for the number of players and civs per player
  void setNumPlayers(int numPlayers) {
    this.numPlayers = numPlayers;
  }

  void setNumCivs(int numCivs) {
    this.numCivs = numCivs;
  }

  void toggleCivBan(int index) {
    if (bannedCivs.contains(index)) {
      log("Unbanning civ ${globals.civList[index]}");
      bannedCivs.remove(index);
    } else {
      log("Banning civ ${globals.civList[index]}");
      bannedCivs.add(index);
    }
  }

  void resetBans() {
    bannedCivs.clear();
    log("Bans reset.");
    notifyListeners();
  }

  void logConfiguration() {
    log("Draft Configuration:");
    log("  numPlayers: $numPlayers");
    log("  numCivs: $numCivs");
  }

  void runDraft() {
    // Clear past draft results
    draftResults.clear();
    draftChoices.clear();

    // Log the current configuration
    logConfiguration();

    // Get a list of all the civs that are not banned
    List<int> civIndexList = Iterable<int>.generate(globals.civList.length).toList();
    civIndexList.removeWhere((int index) => bannedCivs.contains(index));

    // Shuffle this list
    civIndexList.shuffle();

    // First pick nPlayers x nCivs from the list of unbanned civs
    final List<int> draftedCivIndices = civIndexList.sublist(0, numPlayers * numCivs);

    // Add the drafted civs to the draft results where each player gets numCivs
    for (int i = 0; i < numPlayers; i++) {
      draftResults.add(draftedCivIndices.sublist(i * numCivs, (i + 1) * numCivs));
    }

    // Notify listeners that the draft has finished
    log("Draft Results: $draftResults");
    notifyListeners();
  }

  void selectCiv(int playerNumber, int civIndex) {
    if (civIndex < 0) {
      log("Random selected");
      draftChoices[playerNumber] = -1;
      notifyListeners();
      return;
    }

    log("Selecting civ ${globals.civList[civIndex]}");
    draftChoices[playerNumber] = civIndex;
    notifyListeners();
  }

  void banDraftChoices() {
    // Remove the civs that were selected from the list of banned civs
    bannedCivs.addAll(draftChoices.values.where((int index) => index >= 0));
    log("Banned civs: $draftChoices");
    notifyListeners();
  }
}
