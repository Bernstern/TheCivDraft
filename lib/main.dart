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
          child: NumberPicker(update: () => {}, text: "Test", defaultValue: 3, min: 1, max: 3),
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

/*
  Stateful widget that takes which a update function to change 
  as well as the text to display widget.
*/
class NumberPicker extends StatefulWidget {
  const NumberPicker({
    Key? key,
    required this.update,
    required this.text,
    required this.defaultValue,
    required this.min,
    required this.max,
  }) : super(key: key);

  final Function update;
  final String text;
  final int defaultValue;
  final int min;
  final int max;

  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  int _value = 0;

  @override
  void initState() {
    super.initState();
    _value = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.text, style: mediumTextStyle),
        const SizedBox(width: 8.0),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            setState(() {
              _value = math.max(_value - 1, widget.min);
              widget.update(_value);
            });
          },
        ),
        Text(_value.toString(), style: mediumTextStyle),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              _value = math.min(_value + 1, widget.max);
              widget.update(_value);
            });
          },
        ),
      ],
    );
  }
}
