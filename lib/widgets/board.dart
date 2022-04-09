import 'package:flutter/material.dart';
import 'package:worddle/models/word_model.dart';
import 'package:worddle/widgets/borad_tile.dart';

class Board extends StatelessWidget {
  final List<Word> board;
  const Board({required this.board, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: board
          .map(
            (word) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: word.letters
                  .map((letter) => BoardTile(letter: letter))
                  .toList(),
            ),
          )
          .toList(),
    );
  }
}
