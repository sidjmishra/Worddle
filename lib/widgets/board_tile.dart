import 'package:flutter/material.dart';
import 'package:worddle/models/letter_model.dart';

class BoardTile extends StatelessWidget {
  final Letter letter;
  const BoardTile({required this.letter, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      height: 48.0,
      width: 48.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: letter.backgroundColor,
        border: Border.all(color: letter.borderColor),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        letter.val,
        style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
