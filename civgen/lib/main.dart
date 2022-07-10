import 'dart:developer';
import 'package:civgen/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:responsive_grid_list/responsive_grid_list.dart';

import 'globals.dart' as globals;

final Uri url = Uri.parse('https://www.buymeacoffee.com/bernstern');
void _launchUrl() async {
  if (!await launchUrl(url)) throw 'Could not launch $url';
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Civ Gen',
      theme: theme,
      home: const HomePage(title: 'The Draft'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 32),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).cardColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Center(child: Column(children: const [IntroBlurb(), SetupCard()])),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _launchUrl,
        tooltip: 'Buy me a coffee',
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.coffee_rounded),
      ),
    );
  }
}

class IntroBlurb extends StatefulWidget {
  const IntroBlurb({super.key});

  @override
  State<IntroBlurb> createState() => _IntroBlurbState();
}

class _IntroBlurbState extends State<IntroBlurb> {
  bool _isHidden = true; // TODO change this later to false
  String rules = '';

  void _hideWidget() {
    setState(() {
      log("Hiding intro widget");
      _isHidden = true;
    });
  }

  Future<String> loadRules(BuildContext context) async {
    return await rootBundle.loadString("rules.txt");
  }

  @override
  Widget build(BuildContext context) {
    loadRules(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible: !_isHidden,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CardTitle(title: "The Civilization Draft"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: loadRules(context),
                  builder: (context, snapshot) => (Text(
                    '${snapshot.data}',
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  )),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: _hideWidget,
                    style: buttonStyle,
                    child: Text(
                      'Hide',
                      style: largeTextStyle,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class SetupCard extends StatefulWidget {
  const SetupCard({Key? key}) : super(key: key);

  @override
  State<SetupCard> createState() => _SetupCardState();
}

class _SetupCardState extends State<SetupCard> {
  final String title = 'Setup';

  void updateNumPlayers(int numPlayers) {
    globals.numPlayers = numPlayers;
  }

  void updateNumCivs(int numCivs) {
    globals.numCivs = numCivs;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CardTitle(title: "Draft Setup"),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Please select the number of players and civilizations per player.",
                  style: TextStyle(fontSize: 16)),
            ),
            GridView(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6, childAspectRatio: 5),
              children: [
                Container(),
                Container(
                    alignment: Alignment.centerRight,
                    child: const Text(
                      "Players",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )),
                LabeledSlider(
                  title: "Players",
                  initialValue: globals.numPlayers,
                  updateFunction: updateNumPlayers,
                  maxValue: globals.maxPlayers,
                ),
                Container(
                    alignment: Alignment.centerRight,
                    child: const Text(
                      "Civs Per Player",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )),
                LabeledSlider(
                  title: "Civs",
                  initialValue: globals.numCivs,
                  updateFunction: updateNumCivs,
                  maxValue: globals.maxCivs,
                ),
                Container(),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Please select the civs you wish to ban from the draft.", style: TextStyle(fontSize: 16)),
            ),
            // TODO: Once the google integration works, just show all civs by default but make played civs pre banned
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 16.0, right: 16.0, bottom: 16.0),
              child: CivList(),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: () {},
                style: buttonStyle,
                child: Text(
                  'Draft',
                  style: largeTextStyle,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LabeledSlider extends StatefulWidget {
  const LabeledSlider(
      {Key? key, required this.title, required this.initialValue, required this.updateFunction, required this.maxValue})
      : super(key: key);

  final String title;
  final int initialValue;
  final int maxValue;
  final Function updateFunction;

  @override
  State<LabeledSlider> createState() => _LabeledSliderState();
}

class _LabeledSliderState extends State<LabeledSlider> {
  double _currentValue = -1;

  @override
  Widget build(BuildContext context) {
    // Set the current value to the initial value of the parent
    if (_currentValue == -1) {
      _currentValue = widget.initialValue.toDouble();
    }
    return Slider(
      value: _currentValue,
      min: 2.0,
      max: widget.maxValue.toDouble(),
      label: _currentValue.toString(),
      divisions: widget.maxValue - 2,
      inactiveColor: Theme.of(context).errorColor,
      activeColor: Theme.of(context).primaryColor,
      thumbColor: Theme.of(context).cardColor,
      onChanged: (double value) {
        setState(() {
          _currentValue = value.round().toDouble();
        });
        widget.updateFunction(value.toInt());
      },
    );
  }
}

class CivList extends StatefulWidget {
  const CivList({Key? key}) : super(key: key);

  @override
  State<CivList> createState() => _CivListState();
}

class _CivListState extends State<CivList> {
  void toggleCivBan(int index) {
    globals.isBannedList[index] = !globals.isBannedList[index];
    log("Toggled civ ban for civ ${globals.civList[index]}");
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontSize: 16,
      color: Theme.of(context).primaryColor,
    );

    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(primary: Theme.of(context).cardColor);
    final ButtonStyle bannedStyle = ElevatedButton.styleFrom(primary: Theme.of(context).cardColor.withOpacity(0.5));

    final List civIndexList = Iterable<int>.generate(globals.civList.length).toList();

    return ResponsiveGridList(
      minItemWidth: 140,
      horizontalGridSpacing: 16,
      verticalGridSpacing: 16,
      shrinkWrap: true,
      children: civIndexList
          .map((index) => OutlinedButton(
                onPressed: () => setState(() {
                  toggleCivBan(index);
                }),
                style: globals.isBannedList[index] ? bannedStyle : buttonStyle,
                child: Text(globals.civList[index], style: textStyle),
              ))
          .toList(),
    );
  }
}

class DraftResult extends StatefulWidget {
  const DraftResult({Key? key}) : super(key: key);

  @override
  State<DraftResult> createState() => _DraftResultState();
}

// Widget for the title of a card
class CardTitle extends StatelessWidget {
  const CardTitle({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        softWrap: true,
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
