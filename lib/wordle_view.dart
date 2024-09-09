import 'package:flutter/material.dart';
import 'package:word_hurdle_puzzle/wordle.dart';

class WordleView extends StatelessWidget {
  final Wordle wordle;
  const WordleView({super.key, required this.wordle});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration:BoxDecoration(
        shape: BoxShape.circle,
        color: wordle.isCorrect
            ? Colors.greenAccent
            : wordle.existsinTarget
            ? Colors.yellowAccent
            : wordle.doesNotExistinTarget
            ? Colors.redAccent
            : null,
        border: Border.all(
          color:  Colors.cyan,
          width:1.5,
        ),
      ),
      child:Text(wordle.letter, style:TextStyle(
        fontSize: 16,
        color:wordle.existsinTarget ? Colors.black :
            wordle.doesNotExistinTarget ? Colors.black :
            wordle.isCorrect ? Colors.black
                :Colors.white,
      ))
    );
  }
}
