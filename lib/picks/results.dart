import 'dart:developer';

import 'package:civgen/models.dart';
import 'package:civgen/shared/helpers.dart';
import 'package:civgen/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultsTable extends StatelessWidget {
  const ResultsTable({super.key, required this.results});

  final Map<int, Map<int, String>> results;

  Widget formatTableText(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          text,
          style: mediumTextStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int numPlayers = context.select<DraftConfiguration, int>((conf) => conf.setupPlayers.value);
    log("Building results table with $numPlayers players for ${results.length} games...");

    // Creat a row for the player names
    TableRow playerNames = TableRow(
      children: [
        // First cell is empty
        formatTableText(""),
        // Fill in the rest of the cells with the player names
        for (int i = 0; i < numPlayers; i++)
          Center(
            child: formatTableText(
              "Player ${i + 1}",
            ),
          ),
      ],
    );

    // Create a row for each game that has a pick
    List<TableRow> gameRows = [];
    for (int game = 0; game < results.length; game++) {
      // Fill in each row - first with the game number
      List<Widget> gameRow = [formatTableText("Game ${game + 1}")];

      // Then fill in the picks for each player
      for (int player = 0; player < numPlayers; player++) {
        String pick = results[game]![player] ?? "";

        gameRow.add(
          Center(
            child: fetchIconForLeader(pick),
          ),
        );
      }
      gameRows.add(TableRow(children: gameRow));
    }

    // If the length of the results is 0 return an empty container
    if (results.isEmpty) {
      return Container();
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.primaryColorDark,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Table(
        border: TableBorder.symmetric(
          outside: BorderSide.none,
          inside: BorderSide(width: 2, color: theme.scaffoldBackgroundColor, style: BorderStyle.solid),
        ),
        children: [playerNames, ...gameRows],
      ),
    );
  }
}
