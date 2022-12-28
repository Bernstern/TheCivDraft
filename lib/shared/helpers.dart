import 'dart:developer';

import 'package:civgen/globals.dart';
import 'package:flutter/material.dart';

String undefinedPath = "images/undefined.svg";

String leaderNameToImage(String leaderName) {
  String path = undefinedPath;
  if (civMap.containsKey(leaderName)) {
    path = "images/${civMap[leaderName]!}.png";
  } else {
    log("Leader name $leaderName not found in civMap, using undefined path");
  }
  return path;
}

Widget fetchIconForLeader(String leaderName) {
  return Image.asset(leaderNameToImage(leaderName), width: 50, height: 50, errorBuilder: (context, error, stackTrace) {
    return Image.asset(
      "images/undefined.png",
      width: 50,
      height: 50,
      color: Colors.white,
    );
  });
}
