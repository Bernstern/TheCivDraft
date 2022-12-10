// ignore_for_file: depend_on_referenced_packages

import 'package:civgen/setup/setup.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'dart:developer';
import 'dart:math' as math;
import 'package:civgen/styles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:oktoast/oktoast.dart';

import 'globals.dart' as globals;
import 'models.dart';
import 'text/intro.dart';

final Uri url = Uri.parse('https://www.buymeacoffee.com/bernstern');

void main() {
  runApp(const DraftApp());
}

class DraftApp extends StatelessWidget {
  const DraftApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => DraftConfiguration(),
          )
        ],
        child: MaterialApp(
          title: "Winter Games Draft",
          initialRoute: "/",
          theme: theme,
          routes: {
            "/": (context) => const SetupPage(),
          },
        ));
  }
}

class SetupPage extends StatelessWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a list of all the widgets that will be displayed, the intro blurb
    // and the setup widgets
    List<Widget> setupCards = [
      const RoundedBox(text: introText),
      for (var config in context.read<DraftConfiguration>().getSetupConfig)
        NumberPicker(
            update: config.update ?? (value) => log("No update function"),
            text: config.text,
            defaultValue: config.value,
            min: config.min,
            max: config.max),
    ];

    // Keep track of which card is active
    int activeCard = 2;

    // Visible cards will be the active card and all cards prior
    List<Widget> previousCards = setupCards.sublist(0, activeCard);

    // Add an opacity to the inactive cards
    for (int i = 0; i < previousCards.length; i++) {
      previousCards[i] = Opacity(
        opacity: 0.5,
        child: previousCards[i],
      );
    }

    return Scaffold(
        body: Center(
            child: FractionallySizedBox(
                alignment: Alignment.center,
                // TODO: Make this responsive to the screen size, basically have a min and max width
                widthFactor: 0.5,
                // Create a column where the active card is centered on the screen and the previous cards
                //   are above with icons for up and down on the right of the active card
                child: LayoutGrid(columnSizes: [
                  1.fr,
                  50.px
                ], rowSizes: [
                  1.fr,
                  auto,
                  1.fr
                ], children: [
                  GridPlacement(
                      columnStart: 0,
                      rowStart: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: previousCards,
                      )),
                  GridPlacement(columnStart: 0, rowStart: 1, child: setupCards[activeCard]),
                  GridPlacement(
                      columnStart: 1,
                      rowStart: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.keyboard_arrow_up,
                            color: theme.primaryColorDark,
                            size: 40,
                          ),
                          Icon(Icons.keyboard_arrow_down, color: theme.primaryColorDark, size: 40)
                        ],
                      ))
                ]))));
  }
}
