import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_screen.dart';
import '../providers/word.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    "Hangman",
                    style: TextStyle(
                      fontFamily: "PlayfairDisplay",
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    "The classic word game",
                    style: TextStyle(
                      fontFamily: "PlayfairDisplay",
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
            RaisedButton(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                alignment: Alignment.center,
                child: Text(
                  "Begin",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontFamily: "OpenSans",
                  ),
                ),
              ),
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(GameScreen.routeName);
              },
            )
          ],
        ),
      ),
    );
  }
}
