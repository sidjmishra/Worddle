import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:worddle/models/letter_model.dart';
import 'package:worddle/models/word_model.dart';
import 'package:worddle/widgets/board_tile.dart';

class Board extends StatelessWidget {
  final List<Word> board;
  final List<List<GlobalKey<FlipCardState>>> flipCardKeys;
  const Board({required this.board, required this.flipCardKeys, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: board
          .asMap()
          .map(
            (i, word) => MapEntry(
              i,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: word.letters
                    .asMap()
                    .map(
                      (j, letter) => MapEntry(
                        j,
                        FlipCard(
                          key: flipCardKeys[i][j],
                          flipOnTouch: false,
                          direction: FlipDirection.VERTICAL,
                          front: BoardTile(
                            letter: Letter(
                                val: letter.val, status: LetterStatus.initial),
                          ),
                          back: BoardTile(letter: letter),
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
            ),
          )
          .values
          .toList(),
    );
  }
}
