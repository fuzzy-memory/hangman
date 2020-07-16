import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HTTPException implements Exception {
  final String msg;

  HTTPException(this.msg);

  @override
  String toString() {
    return msg;
  }
}

class Word with ChangeNotifier {
  String _obtainedWord, _blank = "_";

  String get answer {
    return _obtainedWord;
  }

  String get guess {
    return _blank;
  }

  Future<void> getWord() async {
    try {
      _blank = "_";
      final url = "https://random-word-api.herokuapp.com//word?swear=0";
      final res = await http.get(url);
      if (res.statusCode != 200) throw HTTPException(res.statusCode.toString());
      final resData = json.decode(res.body);
      _obtainedWord =
          resData.toString().substring(1, resData.toString().length - 1);
      for (int i = 0; i < _obtainedWord.length - 1; i++) {
        _blank += "_";
      }
      // print("word=$_obtainedWord\nblank=${_blank.length}");
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
