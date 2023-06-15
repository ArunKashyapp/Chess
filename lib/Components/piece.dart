enum ChessPieceType { Elephant, Horse, Camel, King, Queen, Soldier }

class ChessPieces {
  final ChessPieceType type;
  final bool isWhite;
  final String images;

  ChessPieces({required this.images, required this.type,required this.isWhite});
}
