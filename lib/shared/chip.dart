import 'package:civgen/styles.dart';
import 'package:flutter/material.dart';

Padding nationChip(String leaderName, String nationIcon) {
  return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2), color: theme.highlightColor),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/$nationIcon'),
              Text(leaderName, style: largeTextStyle),
            ],
          )));
}
