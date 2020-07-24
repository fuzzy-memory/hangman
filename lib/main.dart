import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/appstate.dart';
import 'providers/word.dart';
import 'screens/home_screen.dart';
import 'screens/game_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppThemeState()),
        ChangeNotifierProvider.value(value: Word()),
      ],
      child: Consumer<AppThemeState>(
        builder: (ctx, appstate, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Hangman',
          theme: ThemeData(
            fontFamily: "OpenSans",
            primarySwatch: Colors.indigo,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          darkTheme: ThemeData(
            fontFamily: "OpenSans",
            brightness: Brightness.dark,
            primaryColor: Color.fromRGBO(72, 101, 129, 1),
          ),
          themeMode: appstate.isDark ? ThemeMode.dark : ThemeMode.light,
          home: HomeScreen(),
          routes: {
            HomeScreen.routeName: (ctx) => HomeScreen(),
            GameScreen.routeName: (ctx) => GameScreen(),
            SettingsScreen.routeName: (ctx) => SettingsScreen(),
          },
        ),
      ),
    );
  }
}
