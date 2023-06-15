import 'package:chess/Components/piece.dart';
import 'package:chess/values/Colors.dart';
import 'package:flutter/material.dart';

class Squares extends StatelessWidget {
  Squares(
      {super.key,
      required this.isWhite,
      required this.pieces,
      required this.isSelected,
      required this.isValidMove,
      required this.onTap});

  final bool isWhite;
  final bool isValidMove;
  final bool isSelected;
  final ChessPieces? pieces;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Color? squreColor;
    if (isSelected) {
      squreColor = Colors.yellow;
    } else if (isValidMove) {
      squreColor = isWhite ? forgroundcolor : backgroundcolor;
    } else {
      squreColor = isWhite ? forgroundcolor : backgroundcolor;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: squreColor,
            border: isValidMove
                ? Border.all(
                    color: Colors.yellow, width: 2, style: BorderStyle.solid)
                : Border.all()),
        child: pieces != null
            ? Image.asset(
                pieces!.images,
              )
            : null,
      ),
    );
  }
}
