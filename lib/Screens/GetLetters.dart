import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lettersgametask/Model/LettersModel.dart';
import 'package:lettersgametask/Model/TextModel.dart';
import 'package:lettersgametask/Reposatory/LettersReposatory.dart';

import '../Reposatory/TextReposatory.dart';

class GetLetters extends StatefulWidget {
  @override
  State<GetLetters> createState() {
    return GetLettersState();
  }
}

class GetLettersState extends State<GetLetters> {
  LettersModel? lettersModelResponse;
  TextModel? TextModelResponse;

  List<String> selectedLetters = [];
  List<String> MatchLetters = [];

  //to get letters
  //array to save letters
  List<String> Letters = [];

  //array to save Words
  List<String> Words = [];

  //to get word
  List<int> selectedIndices = [];
  List<String> matchedWords = [];
  List<String> selectedWords = [];

  String enteredText = '';
  List<String> coloredWords = [];

  @override
  void initState() {
    super.initState();
    // Simulating API response
    //lettersModelFuture = fetchLettersFromAPI();
    ShowLetterandText();
    //show build in run
    print(LettersModel());
    print(TextModel());
  }

  //show letters and text
  Future<void> ShowLetterandText() async {
    try {
      lettersModelResponse = await LettersReposatory().getLetters();
      TextModelResponse = await TextReposatory().getAllText();
      setState(() {});
    } on Exception catch (error) {
      print('error message');
    }
  }

  //###################################
  void updateEnteredText() {
    setState(() {
      enteredText = selectedIndices.map((index) => Letters[index]).join();
    });
  }
// check words from text model
  void checkWordMatch() {
    String selectedWord = selectedLetters.join();
    bool isMatched = TextModel()?.word?.contains(selectedWord) ?? false;
    setState(() {
      if (isMatched) {
        if (!selectedWords.contains(selectedWord)) {
          selectedWords.add(selectedWord);
        } else {
          MatchLetters.add(selectedWord);
        }
      }
    });
  }



  void clearSelection() {
    selectedLetters.clear();
    matchedWords.clear();
  }

  void colorWords() {
    if (TextModelResponse != null) {
      coloredWords = [];
      List<String> modelWords = TextModelResponse!.word!;

      for (String word in modelWords) {
        if (selectedLetters.join().contains(word) &&
            !coloredWords.contains(word)) {
          coloredWords.add(word);
        }
      }
    }
  }

  //###################################

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: Text('Letter Game'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 15, // number of items in each row
                mainAxisSpacing: 8.0, // spacing between rows
                crossAxisSpacing: 8.0, // spacing between columns
              ),
              padding: EdgeInsets.all(2.0),
              // padding around the grid
              itemCount: lettersModelResponse?.letters?.length ?? 0,
              // total number of items
              itemBuilder: (BuildContext context, int index) {
                String letter = lettersModelResponse?.letters?[index] ?? '';

                //checkif user selected letter or not
                //bool isSelected = selectedLetters.contains(letter);

                //checkif user selected letter or not
                //bool isSelected = selectedLetters.contains(letter);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      bool match = true;
                      // selectedLetter = Words as String?;
                      //check if user selected letter or not and ollow un select it
                      if (selectedIndices.contains(index)) {
                        selectedIndices.remove(index); // Deselect letter
                      } else {
                        selectedIndices.add(index); // Select letter
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectedIndices.contains(index)
                          ? Colors.purple.shade100
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: TextModelResponse?.word?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                // total number of items
                String words = TextModelResponse?.word?[index] ?? '';
                Words =
                matchedWords.isNotEmpty ? matchedWords : ['No words found'];
                //to check if is matched or not
                // Check if the word is matched (contained in selected letters)
                //  bool isMatched = selectedIndices.every(Words.contains);
                bool isMatched = selectedWords.contains(words);
                Color textColor = isMatched ? Colors.green.shade900 : Colors.greenAccent;
                bool containsSelectedLetters = selectedLetters.join().contains(words);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLetters = Words;
                      checkWordMatch();
                    });
                  },

                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isMatched ? Colors.purpleAccent.shade100 : Colors
                          .white,
                      borderRadius: BorderRadius.circular(25.0),
                      border: Border.all(
                        color: isMatched ? Colors.purple : Colors.grey,
                      ),
                    ),
                    margin: EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 16.0),
                    child: ListTile(
                      title: Text(
                        words,
                        style: TextStyle(
                          color: containsSelectedLetters ? textColor : Colors.black,

                        ),
                      ),
                      trailing: Icon(
                        isMatched ? Icons.check_circle : Icons.circle,
                        color: isMatched ? Colors.green : Colors.purple.shade50,
                      ),
                    ),
                  ),

                );
              },
            ),
          ),

          ElevatedButton(
            onPressed: () {
              //to check if word matches text in text model
               checkWordMatch();
               clearSelection();
              //store the selected letters and update it each time the user clicks on a letter
               selectedLetters = selectedIndices.map((
                  index) => lettersModelResponse?.letters?[index] ?? '')
                  .toList();
              print('Selected Letters: $selectedLetters');

              if (TextModelResponse != null) {
                List<String> modelWords = TextModelResponse!.word!;

                if (selectedWords.length == modelWords.length &&
                    modelWords.every((word) => selectedWords.contains(word))) {
                  colorWords();
                  // All words are selected
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Congratulations!'),
                        // content: Text('You have selected all the words.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              clearSelection();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Not all words are selected
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('you contain a word  '),
                        // content: Text('Please select all the words to proceed.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              clearSelection();
                            },
                            child: Text('OK'),

                          ),
                        ],
                      );
                    },
                  );
                }
              }
            },
            child: Text('Show Letters '),
          ),
        ],
      ),
    );
  }

  void clearSelectedLetters() {
    setState(() {
      selectedIndices.clear();
    });
  }
}
