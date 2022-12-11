import 'dart:html';

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
    return SetupContainer(
        child: Text(
      text,
      style: mediumTextStyle,
      textAlign: TextAlign.center,
    ));
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

class SetupPage extends StatefulWidget {
  const SetupPage({Key? key}) : super(key: key);
  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  int _activeCardIndex = 0;
  int _maxCardIndex = 0;
  bool _showIntro = true;

  @override
  void initState() {
    super.initState();
  }

  void nextCard() {
    if (_activeCardIndex < _maxCardIndex - 1) {
      setState(() {
        _activeCardIndex++;
      });
    }
  }

  void previousCard() {
    if (_activeCardIndex > 0) {
      setState(() {
        _activeCardIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Create a list of all the widgets that will be displayed, the intro blurb
    // and the setup widgets
    List<Widget> setupCards = [
      for (var config in context.read<DraftConfiguration>().getSetupConfig)
        NumberPicker(
            update: config.update ?? (value) => log("No update function"),
            text: config.text,
            defaultValue: config.value,
            min: config.min,
            max: config.max),
    ];

    // Update the max card index
    _maxCardIndex = setupCards.length;

    // Caclulate the offset for each card - active is 0, the rest are offset by
    // the distance from the active card index
    for (int i = 0; i < _maxCardIndex; i++) {
      setupCards[i] = AnimatedSlide(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        offset: Offset(0, 1.5 * (i - _activeCardIndex)),
        child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            opacity: i < _activeCardIndex ? .5 : (i == _activeCardIndex ? 1 : 0),
            child: setupCards[i]),
      );
    }

    // TODO: Make it so that up and down arrow keys can be used to change the active card
    return Scaffold(
        body: Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Visibility(
            visible: !_showIntro,
            child: FractionallySizedBox(
                // TODO: Make this responsive to the screen size, basically have a min and max width
                widthFactor: 0.5,
                child: LayoutGrid(columnSizes: [
                  1.fr,
                  50.px
                ], rowSizes: const [
                  auto
                ], children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: setupCards,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => previousCard(),
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.keyboard_arrow_up,
                          color: theme.primaryColorDark,
                          size: 40,
                        ),
                      ),
                      IconButton(
                        onPressed: () => nextCard(),
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: theme.primaryColorDark,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ])),
          ),
          Visibility(
            visible: _showIntro,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              FractionallySizedBox(widthFactor: 0.75, child: RoundedBox(text: introText)),
              TextButton(
                  onPressed: () => {
                        setState(
                          () => {this._showIntro = false},
                        )
                      },
                  child: RoundedBox(text: "Start Drafting")),
            ]),
          ),
        ],
      ),
    ));
  }
}
