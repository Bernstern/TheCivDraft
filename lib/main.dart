// ignore_for_file: depend_on_referenced_packages

import 'package:civgen/setup/setup.dart';
import 'package:flutter/material.dart';
import 'package:civgen/styles.dart';
import 'package:provider/provider.dart';

import 'models.dart';

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
          theme: theme,
          routes: {
            "/": (context) => const SetupPage(),
          },
        ));
  }
}
