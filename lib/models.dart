import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:civgen/text/intro.dart';

// Make an enum of available pages
enum VisiblePage { setup, bans, picks }

// Set default number of players, number of games, number of bans,
class SetupConfig {
  SetupConfig({required this.value, required this.min, required this.max, required this.text, this.update});

  int value;
  int min;
  int max;
  String text;
  // TODO: We might be able to have this just be a setter and then have the
  //  change notifier notify the listeners only on a save
  Function? update;
}

SetupConfig initialSetupPlayers = SetupConfig(
  value: 2,
  min: 2,
  max: 8,
  text: pickPlayers,
);

SetupConfig initialSetupGames = SetupConfig(
  value: 1,
  min: 1,
  max: 5,
  text: pickGames,
);

SetupConfig initialSetupBans = SetupConfig(
  value: 2,
  min: 1,
  max: 4,
  text: pickBans,
);

class DraftConfiguration extends ChangeNotifier {
  DraftConfiguration() {
    // Link in the update functions to the setup configs
    setupPlayers.update = setNumPlayers;
    setupGames.update = setNumGames;
    setupBans.update = setNumBans;
  }

  SetupConfig setupPlayers = initialSetupPlayers;
  SetupConfig setupGames = initialSetupGames;
  SetupConfig setupBans = initialSetupBans;

  // Set the default page to be the setup page
  VisiblePage page = VisiblePage.setup;

  List<SetupConfig> get getSetupConfig => [
        setupPlayers,
        setupGames,
        setupBans,
      ];

  // Keep track of the banned civs
  List<String> bannedCivs = ["Shaka", "Philip II", "Kristina", "Gilgamesh", "Bà Triệu", "Robert the Bruce"];

  void setNumPlayers(int num) {
    setupPlayers.value = num;
    log("Num players: $num");
  }

  void setNumGames(int num) {
    setupGames.value = num;
    log("Num games: $num");
  }

  void setNumBans(int num) {
    setupBans.value = num;
    log("Num bans: $num");
  }

  void setBans(List<String> civs) {
    bannedCivs = civs;
    log("Banned civs: $civs");
  }

  void setActivePage(VisiblePage newPage) {
    page = newPage;
    log("Active page: $newPage");
    notifyListeners();
  }
}
