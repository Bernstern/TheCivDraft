import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:civgen/text/intro.dart';

// Make an enum of available pages
enum VisiblePage { setup, bans }

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
  value: 3,
  min: 2,
  max: 8,
  text: pickPlayers,
);

SetupConfig initialSetupGames = SetupConfig(
  value: 4,
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

  // St the default page to be the setup page
  VisiblePage page = VisiblePage.setup;

  List<SetupConfig> get getSetupConfig => [
        setupPlayers,
        setupGames,
        setupBans,
      ];

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

  void setActivePage(VisiblePage newPage) {
    page = newPage;
    notifyListeners();
  }
}
