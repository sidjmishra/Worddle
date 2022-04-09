import 'package:flutter/material.dart';
import 'package:worddle/models/letter_model.dart';

const _qwerty = [
  ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
  ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
  ['ENTER', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'DEL'],
];

class Keyboard extends StatelessWidget {
  const Keyboard(
      {required this.onKeyTapped,
      required this.onDeleteTapped,
      required this.onEnterTapped,
      required this.letters,
      Key? key})
      : super(key: key);

  final void Function(String) onKeyTapped;
  final VoidCallback onDeleteTapped;
  final VoidCallback onEnterTapped;
  final Set<Letter> letters;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _qwerty
          .map(
            (keyRow) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: keyRow.map(
                (letter) {
                  if (letter == 'DEL') {
                    return _KeyboardButton.delete(onTap: onDeleteTapped);
                  } else if (letter == "ENTER") {
                    return _KeyboardButton.enter(onTap: onEnterTapped);
                  }

                  final letterKey = letters.firstWhere(
                    (element) => element.val == letter,
                    orElse: () => Letter.empty(),
                  );

                  return _KeyboardButton(
                    onTap: () => onKeyTapped(letter),
                    letter: letter,
                    backgroundColor: letterKey != Letter.empty()
                        ? letterKey.backgroundColor
                        : Colors.grey,
                  );
                },
              ).toList(),
            ),
          )
          .toList(),
    );
  }
}

class _KeyboardButton extends StatelessWidget {
  const _KeyboardButton(
      {this.height = 48.0,
      this.width = 30.0,
      required this.onTap,
      required this.backgroundColor,
      required this.letter,
      Key? key})
      : super(key: key);

  final double height;
  final double width;
  final VoidCallback onTap;
  final Color backgroundColor;
  final String letter;

  factory _KeyboardButton.delete({required VoidCallback onTap}) =>
      _KeyboardButton(
        width: 56.0,
        onTap: onTap,
        backgroundColor: Colors.grey,
        letter: 'DEL',
      );

  factory _KeyboardButton.enter({required VoidCallback onTap}) =>
      _KeyboardButton(
        width: 56.0,
        onTap: onTap,
        backgroundColor: Colors.grey,
        letter: 'ENTER',
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4.0),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height,
            width: width,
            alignment: Alignment.center,
            child: Text(
              letter,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
