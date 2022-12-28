import 'dart:developer';

import 'package:civgen/globals.dart';
import 'package:flutter/material.dart';

String undefinedPath = "images/undefined.svg";

String leaderNameToImage(String leaderName) {
  String path = undefinedPath;
  if (civMap.containsKey(leaderName)) {
    path = "images/Icon_civilization_${civMap[leaderName]!}.webp";
  } else {
    log("Leader name $leaderName not found in civMap, using undefined path");
  }
  return path;
}

Widget fetchIconForLeader(String leaderName) {
  return Image.asset(leaderNameToImage(leaderName), width: 40, height: 40, errorBuilder: (context, error, stackTrace) {
    return Image.asset(
      "images/undefined.png",
      width: 40,
      height: 40,
      color: Colors.white,
    );
  });
}
