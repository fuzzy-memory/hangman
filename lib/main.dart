import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/word.dart';
import 'screens/home_screen.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Word()),
      ],
      child: Consumer<Word>(
        builder: (ctx, wordProvider, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Hangman',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: Color.fromRGBO(72, 101, 129, 1),
          ),
          themeMode: ThemeMode.dark,
          home: HomeScreen(),
          routes: {
            HomeScreen.routeName: (ctx) => HomeScreen(),
            GameScreen.routeName: (ctx) => GameScreen(),
          },
        ),
      ),
    );
  }
}
