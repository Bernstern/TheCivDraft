// ignore_for_file: depend_on_referenced_packages

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
    return const Scaffold(
      body: Center(
        child: FractionallySizedBox(
          alignment: Alignment.center,
          widthFactor: 0.5,
          child: RoundedBox(text: introText),
        ),
      ),
    );
  }
}

// Stateless widget is just a box with rounded corners and text and is noninteractive
class RoundedBox extends StatelessWidget {
  const RoundedBox({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      //
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: theme.primaryColorDark,
      ),
      child: Text(text, style: mediumTextStyle),
    );
  }
}
