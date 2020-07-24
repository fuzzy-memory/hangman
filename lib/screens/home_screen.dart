import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game_screen.dart';
import 'settings_screen.dart';
import '../providers/word.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool clickable = false;
  @override
  void initState() {
    super.initState();
    clickable = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    clickable = true;
  }

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
            !clickable
                ? CircularProgressIndicator()
                : RaisedButton(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 16),
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
                    onPressed: !clickable
                        ? null
                        : () async {
                            try {
                              setState(() {
                                clickable = false;
                              });
                              await Provider.of<Word>(context, listen: false)
                                  .getWord();
                              Navigator.of(context)
                                  .pushNamed(GameScreen.routeName);
                              setState(() {
                                clickable = true;
                              });
                            } catch (error) {
                              _showErrorDialog();
                            }
                          },
                  )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(SettingsScreen.routeName);
        },
        child: Icon(Icons.settings),
      ),
    );
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
}
