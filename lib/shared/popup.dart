import 'package:civgen/shared/submit_button.dart';
import 'package:civgen/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PopUp extends StatelessWidget {
  const PopUp({
    super.key,
    required this.title,
    required this.content,
    required this.actionMessage,
    required this.action,
  });

  final String title;
  final String content;
  final String actionMessage;
  final Function action;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: theme.shadowColor,
      title: Text(title, style: largeTextStyle),
      content: Text(
        content,
        style: mediumTextStyle,
      ),
      actions: [
        SubmitButton(
            onPressed: () => {
                  Navigator.of(context).pop(),
                  action(),
                },
            text: actionMessage),
      ],
    );
  }
}
