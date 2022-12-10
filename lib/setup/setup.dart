import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:civgen/styles.dart';

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
