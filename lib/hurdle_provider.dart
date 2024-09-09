import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:english_words/english_words.dart' as words;
import 'package:word_hurdle_puzzle/wordle.dart';

class HurdleProvider extends ChangeNotifier{
  final random = Random.secure();
  List<String> totalWords = [];
  List<String> rowInputs = [];
  List<String> excludedLetters = [];
  List<Wordle> hurdleBoard = [];
  String targetWord = '';
  int count=0;
  int index=0;
  final lettersPerRow = 5;
  final totalAttempts = 6;
  int attempts = 0;
  bool wins = false;

  init(){
    totalWords = words.all.where((element) => element.length ==5).toList();
    generateBoard();
    generateRandomWord();
  }

  generateBoard(){
    hurdleBoard = List.generate(30,(index) => Wordle(letter:''));
  }

  generateRandomWord(){
    targetWord = totalWords[random.nextInt(totalWords.length)].toUpperCase();
    print(targetWord);
  }

  bool get isAValidWord => totalWords.contains(rowInputs.join('').toLowerCase());

  bool get shouldCheckForAnswer => rowInputs.length == lettersPerRow;

  bool get noAttemptsLeft => attempts == totalAttempts;

  inputLetter(String letter){
    if(count<lettersPerRow){
      rowInputs.add(letter);
      hurdleBoard[index] = Wordle(letter: letter);
      index++;
      count++;
      notifyListeners();
    }
  }

  deleteLetter(){
    if(rowInputs.isNotEmpty){
      rowInputs.removeAt(rowInputs.length-1);
    }

    if(count>0){
      hurdleBoard[index-1] = Wordle(letter:'');
      count--;
      index--;
      notifyListeners();
    }
  }

  void checkAnswer(){
    final input = rowInputs.join('');
    if(targetWord==input){
      wins = true;
    }
    else{
      _markLetterOnBoard();
      if(attempts < totalAttempts){
        _goToNextRow();
      }
    }
  }

  void _markLetterOnBoard(){
    int i = 0, k = 5;
    switch (attempts) {
      case 1:
        i = 5; k = 10;
        break;
      case 2:
        i = 10; k = 15;
        break;
      case 3:
        i = 15; k = 20;
        break;
      case 4:
        i = 20; k = 25;
        break;
      case 5:
        i = 25; k = 30;
        break;
      default:
        i = 0; k = 5;
        break;
    }
    for(i; i<k; i++){
      if(hurdleBoard[i].letter.isNotEmpty && targetWord.indexOf(hurdleBoard[i].letter)==rowInputs.indexOf(hurdleBoard[i].letter)){
        hurdleBoard[i].isCorrect = true;
        hurdleBoard[i].existsinTarget = false;
      }
      else if(hurdleBoard[i].letter.isNotEmpty && targetWord.contains(hurdleBoard[i].letter)){
        hurdleBoard[i].existsinTarget = true;
      }
      else if(hurdleBoard[i].letter.isNotEmpty && !targetWord.contains(hurdleBoard[i].letter)){
        hurdleBoard[i].doesNotExistinTarget = true;
        excludedLetters.add(hurdleBoard[i].letter);
      }

    }
    notifyListeners();
  }

  void _goToNextRow(){
    attempts++;
    count = 0;
    rowInputs.clear();
  }

  reset(){
    count =0;
    index=0;
    hurdleBoard.clear();
    excludedLetters.clear();
    rowInputs.clear();
    attempts=0;
    wins = false;
    targetWord='';
    generateBoard();
    generateRandomWord();
    notifyListeners();
  }

}