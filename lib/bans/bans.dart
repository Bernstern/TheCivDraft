import 'dart:developer';

import 'package:civgen/shared/chip.dart';
import 'package:civgen/shared/submit_button.dart';
import 'package:civgen/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  Map<String, bool> pressedCivChips = {};

  // Keep track of which chips are pressed
  void onChipPressed(String leaderName) {
    log("Toggling the ban for $leaderName");
    setState(() {
      pressedCivChips[leaderName] = !(pressedCivChips[leaderName] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<NationChip> civChips = [];

    for (var civ in civList) {
      civChips.add(NationChip(
          leaderName: civ["leaderName"],
          nationIcon: 'Icon_civilization_america.webp',
          onChipPressed: () => onChipPressed(civ["leaderName"]),
          chipIsPressed: pressedCivChips[civ["leaderName"]] ?? false));
    }

    ResponsiveGridList grid = ResponsiveGridList(
      rowMainAxisAlignment: MainAxisAlignment.center,
      shrinkWrap: true,
      minItemWidth: 225,
      horizontalGridSpacing: 12,
      verticalGridSpacing: 12,
      children: civChips,
    );

    return MaterialApp(
      title: 'bans',
      home: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.primaryColorDark,
          title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("On The Clock: Player 1"),
            Text(
              "Banning Phase",
              style: largeTextStyle,
            ),
            Text("1:42 Remaining")
          ]),
        ),
        body: Center(
          child: FractionallySizedBox(widthFactor: .6, child: grid),
        ),
        floatingActionButton: AnimatedFloatingSubmitButton(
          text: "Confirm Ban",
          onPressed: () => log("pressed"),
          opacityFunction: () => 1,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
