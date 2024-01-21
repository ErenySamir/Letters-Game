
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:lettersgametask/Model/LettersModel.dart';

class LettersReposatory{
//return type of all model after being parsed and decoded
  Future<LettersModel>getLetters() async{
    http.Response responseLetter = await get(Uri.parse(
        'https://mocki.io/v1/fae471d4-b856-4cde-a77c-1894d5288720'
    ));
print(responseLetter.body.toString()+'test');
    return LettersModel.fromJson(jsonDecode(responseLetter.body));
  }
}