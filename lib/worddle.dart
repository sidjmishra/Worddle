import 'dart:math';

import 'package:flutter/material.dart';
import 'package:worddle/data/word_list.dart';
import 'package:worddle/models/letter_model.dart';
import 'package:worddle/models/word_model.dart';

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

  int _currentWordIndex = 0;

  Word? get _currentWord =>
      _currentWordIndex < _board.length ? _board[_currentWordIndex] : null;

  Word _solution = Word.fromString(
    fiveLetterWords[Random().nextInt(fiveLetterWords.length)].toUpperCase(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Worddle", style: TextStyle(fontSize: 36.0)),
      ),
    );
  }
}
