import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:civgen/styles.dart';

import 'dart:developer';
import 'package:provider/provider.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import 'package:civgen/text/intro.dart';
import 'package:civgen/models.dart';

class SetupContainer extends StatelessWidget {
  const SetupContainer({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // This is the padding around the containter
      padding: const EdgeInsets.all(12.0),
      child: Container(
        // This is the padding inside the container
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: theme.primaryColorDark,
        ),
        child: child,
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
    return SetupContainer(child: Text(text, style: mediumTextStyle));
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

// TODO: Add the notion of the widget that is in focus to take keystroke inputs
//  for the number picker
class _NumberPickerState extends State<NumberPicker> {
  int _value = 0;

  @override
  void initState() {
    super.initState();
    _value = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return SetupContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.text, style: mediumTextStyle),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  setState(() {
                    _value = math.max(_value - 1, widget.min);
                    widget.update(_value);
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(),
                child: Text(_value.toString(), style: mediumTextStyle),
              ),
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                ),
                onPressed: () {
                  setState(() {
                    _value = math.min(_value + 1, widget.max);
                    widget.update(_value);
                  });
                },
              ),
            ],
          )
        ],
      ),
    );
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
