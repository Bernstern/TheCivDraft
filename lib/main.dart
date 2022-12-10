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
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          alignment: Alignment.center,
          // TODO: Make this responsive to the screen size, basically have a min and max width
          widthFactor: 0.5,
          // TODO: Unpack all our values here instead of duplicating the code
          child: NumberPicker(
              update: (value) => context.read<DraftConfiguration>().setNumPlayers(value),
              text: pickPlayers,
              defaultValue: context.read<DraftConfiguration>().numPlayers,
              min: 1,
              max: 3),
        ),
      ),
    );
  }
}
