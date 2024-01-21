
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:lettersgametask/Model/LettersModel.dart';
import 'package:lettersgametask/Model/TextModel.dart';


class TextReposatory{
//return type of all model after being parsed and decoded
  Future<TextModel>getAllText() async{
    http.Response responseText = await get(Uri.parse(
        'https://mocki.io/v1/bbdd7ee5-4e38-481b-a615-c27926f24f1f'
    ));

    return TextModel.fromJson(jsonDecode(responseText.body));
  }
}