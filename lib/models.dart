import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;

// Set default number of players, number of games, number of bans,
const int defaultNumPlayers = 3;
const int defaultNumGames = 3;
const int defaultNumBans = 2;

class DraftConfiguration extends ChangeNotifier {
  int numPlayers = defaultNumPlayers;
  int numGames = defaultNumGames;
  int numBans = defaultNumBans;

  void setNumPlayers(int num) {
    numPlayers = num;
  }

  void setNumGames(int num) {
    numGames = num;
  }

  void setNumBans(int num) {
    numBans = num;
  }
}
