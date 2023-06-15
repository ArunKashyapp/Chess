import 'package:chess/Components/piece.dart';
import 'package:flutter/material.dart';

class DeadPiece extends StatelessWidget {
  final ChessPieces? chessPiece;

  const DeadPiece({
    Key? key,
    required this.chessPiece,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (chessPiece != null) {
      return Container(
        child: Image.asset(
          chessPiece!.images,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return Container(); // Return an empty container if chessPiece is null
    }
  }
}

class DeadPiece2 extends StatelessWidget {
  final ChessPieces? chessPiece;

  const DeadPiece2({
    Key? key,
    required this.chessPiece,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (chessPiece != null) {
      return Container(
        height: 20,
        width: 20,
        child: Image.asset(
          chessPiece!.images,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return Container(); // Return an empty container if chessPiece is null
    }
  }
}
