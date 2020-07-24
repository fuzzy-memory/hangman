import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/word.dart';

class GameScreen extends StatefulWidget {
  static const routeName = "/game-screen";
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool isDarkTheme;
  String winText, assetKey, answer, guess, def;
  int stage;
  bool showKeyboard, win, showMeaning, refreshable;
  List<String> attemptLog = [];
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    refreshable = true;
    showMeaning = false;
    answer = Provider.of<Word>(context, listen: false).answer;
    guess = Provider.of<Word>(context, listen: false).guess;
    def = Provider.of<Word>(context, listen: false).meaning;
    super.initState();
    winText = "lost";
    attemptLog = [];
    showKeyboard = true;
    stage = 1;
    win = false;
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Error!',
          style: TextStyle(color: Colors.red),
        ),
        content: Text("Please check your internet connection and try again"),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void reset() async {
    try {
      final provider = Provider.of<Word>(context, listen: false);
      await provider.getWord();
      setState(() {
        showMeaning = false;
        def = provider.meaning;
        attemptLog = [];
        winText = "lost";
        win = false;
        showKeyboard = true;
        answer = provider.answer;
        guess = provider.guess;
        stage = 1;
        globalKey.currentState.showSnackBar(buildSnack("Reset"));
        print(answer);
        setState(() {
          refreshable = true;
        });
      });
    } catch (e) {
      _showErrorDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    assetKey = isDarkTheme ? "dark" : "light";
    return Scaffold(
      key: globalKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            win
                ? Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: MediaQuery.of(context).size.height * 0.25,
                  )
                : Image.asset(
                    "assets/images/$assetKey/men-0${stage.toString()}.png"),
            refreshable
                ? Text(
                    guess ?? "",
                    style: TextStyle(
                      letterSpacing: 12,
                      fontSize: 30,
                    ),
                  )
                : Text(
                    "Loading word",
                    style: TextStyle(fontSize: 24),
                  ),
            refreshable ? buildKeyboard() : CircularProgressIndicator(),
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: !showMeaning
                    ? null
                    : Container(
                        padding: EdgeInsets.all(16),
                        color: def.isEmpty
                            ? Colors.red
                            : win ? Colors.green : Colors.red,
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width * 0.5,
                        alignment: Alignment.center,
                        child: def ==
                                "There was an error retrieving the definition"
                            ? Text(
                                "There was an error receiving the definition",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22, color: Colors.white),
                              )
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        "Definition of",
                                        style: TextStyle(
                                            fontSize: 19, color: Colors.white),
                                      ),
                                      Text(answer,
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white,
                                              fontFamily: "PlayfairDisplay")),
                                    ],
                                  ),
                                  Text(
                                    def,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: win ? Icon(Icons.check) : Icon(Icons.refresh),
        backgroundColor:
            refreshable ? Theme.of(context).colorScheme.secondary : Colors.grey,
        onPressed: refreshable
            ? () {
                setState(() {
                  refreshable = false;
                });
                reset();
              }
            : null,
      ),
    );
  }

  Widget buildKeyboard() {
    return Container(
      child: showKeyboard
          ? Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    buildKey('Q'),
                    buildKey('W'),
                    buildKey('E'),
                    buildKey('R'),
                    buildKey('T'),
                    buildKey('Y'),
                    buildKey('U'),
                    buildKey('I'),
                    buildKey('O'),
                    buildKey('P'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    buildKey('A'),
                    buildKey('S'),
                    buildKey('D'),
                    buildKey('F'),
                    buildKey('G'),
                    buildKey('H'),
                    buildKey('J'),
                    buildKey('K'),
                    buildKey('L'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    buildKey('Z'),
                    buildKey('X'),
                    buildKey('C'),
                    buildKey('V'),
                    buildKey('B'),
                    buildKey('N'),
                    buildKey('M'),
                  ],
                ),
              ],
            )
          : Text(
              "You $winText",
              style: TextStyle(
                fontFamily: "OpenSans",
                fontSize: 24,
                color: win ? Colors.green : Colors.red,
              ),
            ),
    );
  }

  Widget buildKey(String letter) {
    letter = letter.toLowerCase();
    bool attempted = attemptLog.contains(letter);
    return GestureDetector(
      onTap: attempted
          ? null
          : () {
              setState(() {
                refreshable = true;
              });
              attemptLog.add(letter);
              print(letter + " " + attemptLog.toString());
              if (answer.contains(letter)) {
                var list = answer.split("");
                for (int i = 0; i < answer.length; i++) {
                  if (letter == list[i]) {
                    setState(() {
                      guess = guess.replaceFirst(RegExp("_"), list[i], i);
                    });
                  }
                }
              } else {
                setState(() {
                  stage++;
                });
              }
              if (stage >= 8) {
                setState(() {
                  showKeyboard = false;
                  showMeaning = true;
                  guess = answer;
                });
                return;
              }
              if (!guess.contains(RegExp("_"))) {
                setState(() {
                  win = true;
                  winText = "won";
                  showKeyboard = false;
                  showMeaning = true;
                });
                return;
              }
            },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          // padding: EdgeInsets.all(8),
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: attempted
                ? Colors.grey
                : isDarkTheme ? Colors.teal : Colors.indigo,
          ),
          child: Text(
            letter,
            style: TextStyle(color: Colors.white),
          ),
          alignment: Alignment.center,
        ),
      ),
    );
  }

  Widget buildSnack(String msg) {
    return SnackBar(
      content: Text(
        msg,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      elevation: 5,
      duration: Duration(milliseconds: 700),
      action: SnackBarAction(
        label: "OK",
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
  }
}
