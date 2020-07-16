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
  String answer, guess, winText, assetKey;
  int stage;
  bool showKeyboard, win;
  List<String> attemptLog = [];
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    
    super.initState();
    winText = "lost";
    attemptLog = [];
    showKeyboard = true;
    stage = 1;
    win = false;
    Provider.of<Word>(context, listen: false).getWord().then((value) {
      answer = Provider.of<Word>(context, listen: false).obtainedWord;
      guess = Provider.of<Word>(context, listen: false).blank;
    });
  }

  void reset() async {
    attemptLog = [];
    winText = "lost";
    win = false;
    showKeyboard = true;
    final provider = Provider.of<Word>(context, listen: false);
    await provider.getWord();
    answer = provider.obtainedWord;
    guess = provider.blank;
    stage = 1;
    globalKey.currentState.showSnackBar(buildSnack("Reset"));
  }

  @override
  Widget build(BuildContext context) {
    isDarkTheme=Theme.of(context).brightness==Brightness.dark;
    assetKey=isDarkTheme?"dark":"light";
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
                : Image.asset("assets/images/$assetKey/men-0${stage.toString()}.png"),
            Text(
              guess ?? "",
              style: TextStyle(
                letterSpacing: 12,
                fontSize: 30,
              ),
            ),
            buildKeyboard(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: win ? Icon(Icons.check) : Icon(Icons.refresh),
        onPressed: reset,
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
    return GestureDetector(
      onTap: () {
        letter = letter.toLowerCase();
        if (attemptLog.contains(letter)) return;
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
            guess = answer;
          });
          return;
        }
        if (!guess.contains(RegExp("_"))) {
          setState(() {
            win = true;
            winText = "won";
            showKeyboard = false;
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
            color: isDarkTheme?Colors.teal:Colors.indigo,
          ),
          child: Text(letter, style: TextStyle(color: Colors.white),),
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
      duration: Duration(milliseconds: 1500),
      action: SnackBarAction(
        label: "OK",
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
  }
}
