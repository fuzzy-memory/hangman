import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Word with ChangeNotifier {
  String obtainedWord, blank="_";

  String get word {
    return obtainedWord;
  }

  Future<void> getWord() async {
    try {
      blank="_";
      final url = "https://random-word-api.herokuapp.com//word?swear=0";
      final res = await http.get(url);
      final resData = json.decode(res.body);
      obtainedWord =
          resData.toString().substring(1, resData.toString().length - 1);
      for(int i=0; i<obtainedWord.length-1; i++){
        blank+="_";
      }
      print("word=$obtainedWord\nblank=${blank.length}");
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
