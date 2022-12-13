import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:civgen/styles.dart';

/// A button that is used to submit a form, requires text to display
/// and a function to call when pressed.
class SubmitButton extends StatelessWidget {
  const SubmitButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: theme.hintColor,
      ),
      child: TextButton(
        onPressed: () => onPressed(),
        child: Text(text, style: mediumTextStyle),
      ),
    );
  }
}

class AnimatedFloatingSubmitButton extends StatelessWidget {
  const AnimatedFloatingSubmitButton(
      {Key? key, required this.text, required this.onPressed, required this.opacityFunction})
      : super(key: key);

  final String text;
  final Function onPressed;
  final Function opacityFunction;

  @override
  Widget build(BuildContext context) {
    log("Buildig submit button with opacity ${opacityFunction()}");
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: opacityFunction(),
      child: Visibility(
        visible: opacityFunction() > 0,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: SubmitButton(text: text, onPressed: onPressed),
        ),
      ),
    );
  }
}
