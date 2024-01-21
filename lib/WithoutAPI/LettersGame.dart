import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lettersgametask/WithoutAPI/GameModel.dart';

class LettersGame extends StatefulWidget {
  @override
  State<LettersGame> createState() {
    return LettersGameState();
  }
}

class LettersGameState extends State<LettersGame> {
  List<GameModel> gameModel = [
    GameModel(imagename: 'assets/images/s.jpg', letter: 'S', show: true),
    GameModel(imagename: 'assets/images/A.jpg', letter: 'A', show: true),
    GameModel(imagename: 'assets/images/b.jpg', letter: 'B', show: true),
    GameModel(imagename: 'assets/images/e.jpg', letter: 'E', show: true),
    GameModel(imagename: 'assets/images/f.jpg', letter: 'F', show: true),
    GameModel(imagename: 'assets/images/g.jpg', letter: 'G', show: true),
    GameModel(imagename: 'assets/images/h.jpg', letter: 'H', show: true),
    GameModel(imagename: 'assets/images/e.jpg', letter: 'E', show: true),
    GameModel(imagename: 'assets/images/x.jpg', letter: 'X', show: true),
    GameModel(imagename: 'assets/images/y.jpg', letter: 'Y', show: true),
    GameModel(imagename: 'assets/images/s.jpg', letter: 'S', show: true),
    GameModel(imagename: 'assets/images/t.jpg', letter: 'T', show: true),
    // Add more GameModel objects for other letters
  ];

  List<GameModel> openedCards = [];
  int matchedPairs = 0;
  bool showAllLetters = false; // Flag to track whether to show all letters

  List<String> clickedLetters = []; // List to store clicked letters

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        title: Text('Letter Game'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.visibility),
        //     onPressed: () {
        //       setState(() {
        //         showAllLetters = true; // Set the flag to true
        //       });
        //     },
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 15, // number of items in each row
                mainAxisSpacing: 14.0, // spacing between rows
                crossAxisSpacing: 12.0, // spacing between columns
              ),
              padding: EdgeInsets.all(10.0), // pad// ding around the grid
              itemCount: gameModel.length, // total number of items
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    if (!gameModel[index].show! && openedCards.length < 2) {
                      setState(() {
                        gameModel[index].show = true;
                        openedCards.add(gameModel[index]);
                        clickedLetters.add(gameModel[index]
                            .letter!); // Add the clicked letter to the list
                        if (openedCards.length == 2) {
                          if (openedCards[0].letter == openedCards[1].letter) {
                            openedCards.clear();
                            matchedPairs++;

                          } else {
                            Future.delayed(
                                const Duration(milliseconds: 800), () {
                              setState(() {
                                openedCards.forEach((element) {
                                  element.show = false;
                                });
                                openedCards.clear();
                              });
                            });
                          }
                        }
                      });
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Letter Clicked'),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('The clicked letter is: ${gameModel[index]
                                    .letter}'),
                                SizedBox(height: 8),
                                Text('Clicked Letters: ${clickedLetters.join(
                                    ", ")}'), // Display clicked letters
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: !gameModel[index].show! || showAllLetters
                      ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      // color: Colors.blue,
                    ),
                    child: Center(
                      child: Text(
                        gameModel[index].letter!,
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  )
                      : Image.asset(gameModel[index].imagename!),

                );
              },
            ),
          ),
          SizedBox(height: 16),
          buildClickedLetters(), // Show the clicked letters as text
        ],
      ),
    );
  }

  Widget buildClickedLetters() {
    return Column(
      children: [
        Text(
          'Clicked Letters:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: clickedLetters.map((letter) {
            return Chip(
              label: Text(letter),
              backgroundColor: Colors.blue,
              labelStyle: TextStyle(color: Colors.white),
            );
          }).toList(),
        ),
      ],
    );
  }

}

