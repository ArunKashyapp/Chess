import 'package:chess/gameBoard.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(new ChessGame());
}

class ChessGame extends StatelessWidget {
  const ChessGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameBoard(
        
      ),
    );
  }
}
