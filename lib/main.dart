// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'dart:collection';
import 'dart:developer';
import 'dart:math' as math;
import 'package:civgen/styles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:oktoast/oktoast.dart';

import 'globals.dart' as globals;
import 'models.dart';
import 'text/intro.dart';

final Uri url = Uri.parse('https://www.buymeacoffee.com/bernstern');

// Database references
void _launchUrl() async {
  if (!await launchUrl(url)) throw 'Could not launch $url';
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<SharedPreferences> initSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DraftConfiguration(
            numPlayers: globals.numPlayers,
            numCivs: globals.numCivs,
          ),
        )
      ],
      child: OKToast(
        child: MaterialApp(
          title: 'Civ Gen',
          theme: theme,
          home: const HomePage(title: 'The Draft'),
        ),
      ),
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
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

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
        controller: _scrollController,
        child: Center(
          child: Container(
            alignment: Alignment.center,
            width: math.max(MediaQuery.of(context).size.width * 0.5, 1000),
            child: Center(
                child: Column(children: [
              const IntroBlurb(),
              SetupCard(
                scrollController: _scrollController,
              ),
              const DraftCard()
            ])),
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
  bool _isHidden = false; // TODO change this later to false

  void _hideWidget() {
    setState(() {
      log("Hiding intro widget");
      _isHidden = true;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              Padding(padding: const EdgeInsets.all(8.0), child: Text(rules, style: mediumCopyStyle)),
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
  SetupCard({Key? key, required this.scrollController}) : super(key: key);

  ScrollController scrollController;

  @override
  State<SetupCard> createState() => _SetupCardState();
}

class _SetupCardState extends State<SetupCard> {
  final String title = 'Setup';

  @override
  Widget build(BuildContext context) {
    int currentNumPlayers = context.select<DraftConfiguration, int>((config) => config.numPlayers);
    int currentNumCivs = context.select<DraftConfiguration, int>((config) => config.numCivs);

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
            Container(
              alignment: Alignment.center,
              child: ResponsiveGridList(
                rowMainAxisAlignment: MainAxisAlignment.center,
                minItemWidth: 400,
                horizontalGridSpacing: 16,
                verticalGridSpacing: 16,
                shrinkWrap: true,
                children: [
                  Column(
                    children: [
                      Container(alignment: Alignment.center, child: Text("Players", style: mediumTextStyle)),
                      LabeledSlider(
                        title: "Players",
                        initialValue: currentNumPlayers,
                        updateFunction: (value) => context.read<DraftConfiguration>().setNumPlayers(value),
                        errorMessage: "Unban civs to increase the number of players.",
                        maxValue: globals.maxPlayers,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Civs Per Player",
                          style: mediumTextStyle,
                        ),
                      ),
                      LabeledSlider(
                        title: "Civs",
                        initialValue: currentNumCivs,
                        updateFunction: (value) => context.read<DraftConfiguration>().setNumCivs(value),
                        errorMessage: "Unban civs to increase the number of civs per player.",
                        maxValue: globals.maxCivs,
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Please select the civs you wish to ban from the draft.", style: TextStyle(fontSize: 16)),
            ),
            // TODO: Once the google integration works, just show all civs by default but make played civs pre banned
            const Padding(
              padding: EdgeInsets.only(top: 8, left: 16.0, right: 16.0, bottom: 16.0),
              child: CivList(),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ResponsiveGridList(
                minItemWidth: 100,
                maxItemsPerRow: 4,
                shrinkWrap: true,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<DraftConfiguration>().resetBans();
                    },
                    style: secondaryButtonStyle,
                    child: Text("Reset Bans", style: largeTextStyle),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DraftConfiguration>().runDraft();

                      // Scroll to the bottom of the page where the results are
                      widget.scrollController.animateTo(widget.scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
                    },
                    style: buttonStyle,
                    child: Text(
                      'Draft',
                      style: largeTextStyle,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DraftConfiguration>().loadBansFromDatabase();
                    },
                    style: buttonStyle,
                    child: Text("Load Bans", style: largeTextStyle),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        context.read<DraftConfiguration>().writeBansToDatabase();
                      },
                      style: buttonStyle,
                      child: Text("Save Bans", style: largeTextStyle)),
                ],
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
      {Key? key,
      required this.title,
      required this.initialValue,
      required this.updateFunction,
      required this.maxValue,
      required this.errorMessage})
      : super(key: key);

  final String title;
  final int initialValue;
  final int maxValue;
  final Function updateFunction;
  final String errorMessage;

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
      inactiveColor: Theme.of(context).disabledColor,
      activeColor: Theme.of(context).focusColor,
      thumbColor: Theme.of(context).cardColor,
      onChanged: (double value) {
        // If the update function returns False, show an error toast
        if (!widget.updateFunction(value.toInt())) {
          showErrorToast(widget.errorMessage);
        } else {
          setState(() {
            _currentValue = value.round().toDouble();
          });
        }
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
  @override
  Widget build(BuildContext context) {
    var draftConfig = context.watch<DraftConfiguration>();
    HashSet<int> bannedCivIndices = draftConfig.bannedCivs;

    final List civIndexList = Iterable<int>.generate(globals.civList.length).toList();

    return ResponsiveGridList(
      minItemWidth: 160,
      horizontalGridSpacing: 16,
      verticalGridSpacing: 16,
      shrinkWrap: true,
      children: civIndexList
          .map((index) => Tooltip(
                message: globals.civList[index]["leaderName"],
                textStyle: mediumCopyStyle,
                preferBelow: false,
                child: OutlinedButton(
                  onPressed: () => setState(() {
                    // If toggling the ban returns false, it means we are at the limit of civs we can ban
                    if (!context.read<DraftConfiguration>().toggleCivBan(index)) {
                      showErrorToast("Not enough civs left to ban with the current configuration.");
                    }
                  }),
                  style: bannedCivIndices.contains(index) ? bannedStyle : buttonStyle,
                  child: Text(globals.civList[index]['nationName'],
                      style: bannedCivIndices.contains(index) ? mediumStrikeThroughStyle : mediumTextStyle),
                ),
              ))
          .toList(),
    );
  }
}

void showErrorToast(String message) {
  showToast(
    message,
    textStyle: largeTextStyle,
    backgroundColor: toastColor,
    textPadding: const EdgeInsets.all(8.0),
    dismissOtherToast: true,
    duration: const Duration(seconds: 5),
    radius: 20,
  );
}

class DraftCard extends StatefulWidget {
  const DraftCard({Key? key}) : super(key: key);

  @override
  State<DraftCard> createState() => _DraftCardState();
}

class _DraftCardState extends State<DraftCard> {
  Widget _buildDraftCard(BuildContext context, String title, int playerNumber, int civNumber, bool isSelected) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 160,
        maxWidth: double.infinity,
      ),
      child: OutlinedButton(
        onPressed: () => {context.read<DraftConfiguration>().selectCiv(playerNumber, civNumber)},
        style: isSelected ? buttonStyle : bannedStyle,
        child: Text(
          title,
          style: mediumTextStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var draftConfig = context.watch<DraftConfiguration>();
    List<List<int>> draftResults = draftConfig.draftResults;
    Map<int, int> draftChoices = draftConfig.draftChoices;
    bool hasResults = draftResults.isNotEmpty;
    int numPlayers = draftConfig.numPlayers;
    int numCivs = draftConfig.numCivs;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible: hasResults,
        maintainSize: true,
        maintainState: true,
        maintainAnimation: true,
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
                child: CardTitle(title: "Draft Results"),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "The following civs were drafted, please select the civs you wish to play in the game. Once you have selected a civ, or the random option, for each player, you will be able to ban them from future drafts.",
                  style: mediumCopyStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: numPlayers * (numCivs + 2),
                    shrinkWrap: true,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: numCivs + 2, childAspectRatio: 3),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 0.0, bottom: 8),
                        child: Container(
                          alignment: Alignment.center,
                          child: () {
                            int row = index ~/ (numCivs + 2);
                            int column = index % (numCivs + 2);

                            // If there are no results yet, return an empty widget
                            if (!hasResults) {
                              return Container();
                            }

                            switch (column) {
                              // Case where this is the first entry in the row - show the player number
                              case 0:
                                return Text(
                                  "Player ${row + 1}",
                                  style: mediumTextStyle,
                                );
                              case 1:
                                bool isSelected = draftChoices[row] == -1;
                                return _buildDraftCard(context, "Random", row, -1, isSelected);
                              default:
                                int civIndex = draftResults[row][column - 2];
                                bool isSelected = draftChoices[row] == civIndex;
                                return Tooltip(
                                  message: globals.civList[civIndex]["leaderName"],
                                  preferBelow: false,
                                  textStyle: mediumCopyStyle,
                                  child: _buildDraftCard(
                                      context, globals.civList[civIndex]['nationName'], row, civIndex, isSelected),
                                );
                            }
                          }(),
                        ),
                      );
                    },
                  )),
              Visibility(
                visible: draftChoices.length == numPlayers,
                maintainAnimation: true,
                maintainSize: true,
                maintainState: true,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ElevatedButton(
                    style: secondaryButtonStyle,
                    onPressed: () => {context.read<DraftConfiguration>().banDraftChoices()},
                    child: Text("Ban Selections", style: largeTextStyle),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
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
