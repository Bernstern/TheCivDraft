import 'package:civgen/bans/bans.dart';
import 'package:civgen/picks/picks.dart';
import 'package:civgen/setup/setup.dart';
import 'package:flutter/material.dart';
import 'package:civgen/styles.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'models.dart';

void main() {
  setPathUrlStrategy();
  runApp(const DraftApp());
}

// TODO: make it a reverse snake draft

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
            "/": (context) => Consumer<DraftConfiguration>(
                  builder: (context, draftConfig, child) {
                    switch (draftConfig.page) {
                      // case VisiblePage.setup:
                      //   return const SetupPage();
                      // case VisiblePage.bans:
                      //   return const BansPage();
                      // case VisiblePage.picks:
                      default:
                        return const PicksPage();
                    }
                  },
                ),
          },
        ));
  }
}
