import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:worddle/constants/constants.dart';
import 'package:worddle/data/word_list.dart';
import 'package:worddle/models/letter_model.dart';
import 'package:worddle/models/word_model.dart';
import 'package:worddle/widgets/board.dart';
import 'package:worddle/widgets/keyboard.dart';

enum GameStatus { playing, submitting, lost, won }

class Worddle extends StatefulWidget {
  const Worddle({Key? key}) : super(key: key);

  @override
  State<Worddle> createState() => _WorddleState();
}

class _WorddleState extends State<Worddle> {
  GameStatus _gameStatus = GameStatus.playing;

  final List<Word> _board = List.generate(
      6, (_) => Word(letters: List.generate(5, (_) => Letter.empty())));

  final List<List<GlobalKey<FlipCardState>>> _flipCardKeys = List.generate(
      6, (_) => List.generate(5, (_) => GlobalKey<FlipCardState>()));

  int _currentWordIndex = 0;

  Word? get _currentWord =>
      _currentWordIndex < _board.length ? _board[_currentWordIndex] : null;

  Word _solution = Word.fromString(
    fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase(),
  );

  final Set<Letter> _keyboardLetters = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "WORDDLE",
          style: TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Board(board: _board, flipCardKeys: _flipCardKeys),
          SizedBox(
            height: MediaQuery.of(context).size.height * (0.05),
          ),
          Keyboard(
            onKeyTapped: _onKeyTapped,
            onDeleteTapped: _onDeleteTapped,
            onEnterTapped: _onEnterTapped,
            letters: _keyboardLetters,
          ),
          const Divider(),
          const Text(
            "© 2022, Siddhant Mishra",
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _onKeyTapped(String val) {
    if (_gameStatus == GameStatus.playing) {
      setState(() {
        _currentWord?.addLetter(val);
      });
    }
  }

  void _onDeleteTapped() {
    if (_gameStatus == GameStatus.playing) {
      setState(() {
        _currentWord?.removeLetter();
      });
    }
  }

  Future<void> _onEnterTapped() async {
    if (_gameStatus == GameStatus.playing &&
        _currentWord != null &&
        !_currentWord!.letters.contains(Letter.empty())) {
      _gameStatus = GameStatus.submitting;

      for (var i = 0; i < _currentWord!.letters.length; i++) {
        final currentWordLetter = _currentWord!.letters[i];
        final currentSolutionLetter = _solution.letters[i];

        setState(() {
          if (currentWordLetter == currentSolutionLetter) {
            _currentWord!.letters[i] ==
                currentWordLetter.copyWith(status: LetterStatus.correct);
          } else if (_solution.letters.contains(currentWordLetter)) {
            _currentWord!.letters[i] ==
                currentWordLetter.copyWith(status: LetterStatus.inWord);
          } else {
            _currentWord!.letters[i] =
                currentWordLetter.copyWith(status: LetterStatus.notInWord);
          }
        });

        final letter = _keyboardLetters.firstWhere(
          (element) => element.val == currentWordLetter.val,
          orElse: () => Letter.empty(),
        );
        if (letter.status != LetterStatus.correct) {
          _keyboardLetters
              .removeWhere((element) => element.val == currentWordLetter.val);
          _keyboardLetters.add(_currentWord!.letters[i]);
        }

        await Future.delayed(
          const Duration(milliseconds: 150),
          () => _flipCardKeys[_currentWordIndex][i].currentState?.toggleCard(),
        );
      }

      _checkIfWinOrLoss();
    }
  }

  void _checkIfWinOrLoss() {
    if (_currentWord!.wordString == _solution.wordString) {
      _gameStatus = GameStatus.won;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "You won!",
            style: TextStyle(color: Colors.white),
          ),
          duration: const Duration(days: 1),
          dismissDirection: DismissDirection.none,
          backgroundColor: correctColor,
          action: SnackBarAction(
            onPressed: _restart,
            textColor: Colors.white,
            label: "New Game",
          ),
        ),
      );
    } else if (_currentWordIndex + 1 >= _board.length) {
      _gameStatus = GameStatus.lost;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "You lost! Solutin: ${_solution.wordString}",
            style: const TextStyle(color: Colors.white),
          ),
          duration: const Duration(days: 1),
          dismissDirection: DismissDirection.none,
          backgroundColor: Colors.redAccent[200],
          action: SnackBarAction(
            onPressed: _restart,
            textColor: Colors.white,
            label: "New Game",
          ),
        ),
      );
    } else {
      _gameStatus = GameStatus.playing;
    }
    _currentWordIndex += 1;
  }

  void _restart() {
    setState(() {
      _gameStatus = GameStatus.playing;
      _currentWordIndex = 0;
      _board
        ..clear()
        ..addAll(
          List.generate(
            6,
            (_) => Word(letters: List.generate(5, (_) => Letter.empty())),
          ),
        );

      _solution = Word.fromString(
          fiveLetterWords[Random().nextInt(fiveLetterWords.length)]
              .toUpperCase());

      _flipCardKeys
        ..clear()
        ..addAll(
          List.generate(
            6,
            (_) => List.generate(6, (_) => GlobalKey<FlipCardState>()),
          ),
        );

      _keyboardLetters.clear();
    });
  }
}
