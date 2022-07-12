import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;

class DraftConfiguration extends ChangeNotifier {
  // TODO: Check if there are enough civs left to draft the number of players when banning

  DraftConfiguration({
    required this.numPlayers,
    required this.numCivs,
  });

  int numPlayers;
  int numCivs;

  // Keep track of the indices of banned civs in the current configuration
  HashSet<int> bannedCivs = HashSet<int>();

  // Store results of the draft in a list of of lists of indices of civs
  List<List<int>> draftResults = [];

  // Store the chosen civs in the draft as a map of player number to picked civ index
  Map<int, int> draftChoices = {};

  // Setters for the number of players and civs per player
  bool setNumPlayers(int numPlayers) {
    if (globals.civList.length - bannedCivs.length <= numPlayers * numCivs) {
      log("Not enough civs left to change the number of players");
      return false;
    }
    this.numPlayers = numPlayers;
    return true;
  }

  bool setNumCivs(int numCivs) {
    // Check if setting the number of civs per player is possible
    if (globals.civList.length - bannedCivs.length <= numPlayers * numCivs) {
      log("Not enough civs left to modify the number of civs per player");
      return false;
    }
    this.numCivs = numCivs;
    return true;
  }

  bool toggleCivBan(int index) {
    // You can always unban a civ, no restriction
    if (bannedCivs.contains(index)) {
      log("Unbanning civ ${globals.civList[index]}");
      bannedCivs.remove(index);
      return true;

      // You can't ban a civ if you don't have enough civs left to draft the number of players
    } else if (globals.civList.length - bannedCivs.length <= numPlayers * numCivs) {
      log("Not enough civs left to ban civ ${globals.civList[index]}");
      return false;
    } else {
      log("Banning civ ${globals.civList[index]}");
      bannedCivs.add(index);
      return true;
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

  void writeBansToDatabase() {
    String bans = json.encode(bannedCivs.toList());

    // Write the bans to the shared preferences
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.setString("bans", bans);
    });

    log("Bans written to shared prefs. $bans");
  }

  void loadBansFromDatabase() {
    // Read the bans from the shared preferences
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      String? bans = prefs.getString("bans");
      if (bans != null) {
        // Need to convert this list of strings to a list of ints
        List<int> bansList = (jsonDecode(bans) as List<dynamic>).cast<int>();
        bannedCivs = HashSet<int>.from(bansList);
        log("Bans loaded from shared prefs: $bans");
        notifyListeners();
      } else {
        log("No bans found in shared prefs.");
      }
    });
  }
}
