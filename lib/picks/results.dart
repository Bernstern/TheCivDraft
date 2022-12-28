import 'package:civgen/styles.dart';
import 'package:flutter/material.dart';

class ResultsTable extends StatelessWidget {
  const ResultsTable({super.key, required this.results});

  final Map<int, Map<int, String>> results;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.primaryColorDark,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Text(
            "Results",
            style: largeTextStyle,
          ),
        ],
      ),
    );
  }
}
