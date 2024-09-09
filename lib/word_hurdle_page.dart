import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:word_hurdle_puzzle/hurdle_provider.dart';
import 'package:word_hurdle_puzzle/keyboard_view.dart';
import 'package:word_hurdle_puzzle/wordle_view.dart';
import 'helper_function.dart';

class WordHurdlePage extends StatefulWidget {
  const WordHurdlePage({super.key});

  @override
  State<WordHurdlePage> createState() => _WordHurdlePageState();
}

class _WordHurdlePageState extends State<WordHurdlePage> {

  @override
  void didChangeDependencies(){
    Provider.of<HurdleProvider>(context,listen:false).init();
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Word Hurdle"),
      ),
      body: Center(
        child: Column(
          children:[
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width *0.7,
                child: Consumer<HurdleProvider>(
                  builder: (context, provider, child) => GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:5,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: provider.hurdleBoard.length,
                    itemBuilder: (context,index){
                      final wordle = provider.hurdleBoard[index];
                      return WordleView(wordle: wordle);
                    },
                  ),
                ),
              ),
            ),
            Consumer<HurdleProvider>(
              builder:(context,provider,child) => KeyboardView(
                excludedLetters: provider.excludedLetters,
                onPressed: (value){
                  provider.inputLetter(value);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child:Consumer<HurdleProvider>(
                builder:(context,provider,child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          provider.deleteLetter();
                        },
                        child: const Text('DELETE')
                    ),
                    ElevatedButton(
                        onPressed: (){
                          _submitButton(provider, context);
                        },
                        child: const Text('SUBMIT')
                    )
                  ],
                )
              )
            )
          ]
        ),
      )
    );
  }

  _submitButton(HurdleProvider provider, BuildContext context) {

    if(!provider.isAValidWord){
      showMessage(context, "Not a Valid Word in the Dictionary");
    }
    if(provider.shouldCheckForAnswer){
      provider.checkAnswer();
    }
    if(provider.wins){
      showResult(context: context,
          title: 'You Win',
          body: 'Word - ${provider.targetWord}',
          onPlayAgain: (){
              Navigator.pop(context);
              provider.reset();
          },
          onCancel: (){
            Navigator.pop(context);
          },
      );
    }
    else if(provider.noAttemptsLeft){
      showResult(context: context,
          title: 'You Lost',
          body: 'Word - ${provider.targetWord}',
          onPlayAgain: (){
            Navigator.pop(context);
            provider.reset();
          },
          onCancel: (){
            Navigator.pop(context);
          }
      );
    }
  }
}
