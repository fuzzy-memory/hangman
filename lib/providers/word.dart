import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api.dart';

class Word with ChangeNotifier {
  String _obtainedWord, _blank = "_", _meaning;

  String get answer {
    return _obtainedWord;
  }

  String get guess {
    return _blank;
  }

  String get meaning {
    return _meaning;
  }

  Future<String> _fetch() async {
    final url = "https://wordsapiv1.p.rapidapi.com/words/?random=true";
    final res = await http.get(url, headers: head);
    return json.decode(res.body)["word"];
  }

  Future<void> getWord() async {
    try {
      _blank = "_";
      var resData = await _fetch();
      print(resData);
      while (
          !resData.contains(RegExp(r'^[a-zA-Z0-9]+$')) || resData.length <= 3) {
        print("Running fetch again");
        resData = await _fetch();
      }
      _obtainedWord = resData;
      for (int i = 0; i < _obtainedWord.length - 1; i++) {
        _blank += "_";
      }
      await getMeaning();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> getMeaning() async {
    try {
      final url =
          "https://wordsapiv1.p.rapidapi.com/words/${_obtainedWord.toLowerCase().trim()}/definitions";
      final res = await http.get(url, headers: head);
      final resData = json.decode(res.body);
      _meaning = (resData["definitions"][0]["definition"]);
      print("Fetched meaning: $_meaning");
    } on RangeError {
      print("Range error");
      _meaning = "There was an error retrieving the definition (Word may be an inflection)";
    } catch (e) {
      print(e);
      _meaning = "There was an error retrieving the definition";
    }
  }
}
