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
  List<int> draftResults = [];

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

  void logConfiguration() {
    log("Draft Configuration:");
    log("  numPlayers: $numPlayers");
    log("  numCivs: $numCivs");
  }
}
