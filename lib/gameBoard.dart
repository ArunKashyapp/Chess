import 'package:chess/Components/Sqares.dart';
import 'package:chess/Components/images.dart';
import 'package:chess/Components/piece.dart';
import 'package:chess/Helper/Helper.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'Components/deadPiece.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late List<List<ChessPieces?>> board;
  ChessPieces? selectedPiece;
  int selectedRow = -1;
  int selectedCol = -1;
  List<List<int>> validmoves = [];

  //A list of white pieces that have been taken by the black pieces
  List<ChessPieces> whitePiecesTaken = [];

  //A list of black pieces taken by the white pieces
  List<ChessPieces> blackPiecesTaken = [];

  //A boolean for the turn
  bool isWhiteTurn = true;

  //initial position of kings (keep track to make this to make it easier later to see if is in check  )

  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];

  bool checkStatus = false;

  @override
  void initState() {
    super.initState();
    initializeBoard();
  }

//initialing the board
  void initializeBoard() {
    List<List<ChessPieces?>> newBoard =
        List.generate(8, (index) => List.generate(8, (index) => null));

    for (var i = 0; i < 8; i++) {
      // Soldiers
      newBoard[1][i] = ChessPieces(
          isWhite: false,
          images: BlackImages.BSoldier,
          type: ChessPieceType.Soldier);
      newBoard[6][i] = ChessPieces(
          isWhite: true,
          images: WhiteImages.WSoldier,
          type: ChessPieceType.Soldier);
      // Elephant
      newBoard[0][0] = ChessPieces(
          isWhite: false,
          images: BlackImages.BElephant,
          type: ChessPieceType.Elephant);
      newBoard[0][7] = ChessPieces(
          isWhite: false,
          images: BlackImages.BElephant,
          type: ChessPieceType.Elephant);
      newBoard[7][0] = ChessPieces(
          isWhite: true,
          images: WhiteImages.WElephant,
          type: ChessPieceType.Elephant);
      newBoard[7][7] = ChessPieces(
          isWhite: true,
          images: WhiteImages.WElephant,
          type: ChessPieceType.Elephant);
      // Horses is done
      newBoard[0][1] = ChessPieces(
          isWhite: false,
          images: BlackImages.BHorse,
          type: ChessPieceType.Horse);
      newBoard[0][6] = ChessPieces(
          isWhite: false,
          images: BlackImages.BHorse,
          type: ChessPieceType.Horse);
      newBoard[7][1] = ChessPieces(
          isWhite: true,
          images: WhiteImages.WHorse,
          type: ChessPieceType.Horse);
      newBoard[7][6] = ChessPieces(
          isWhite: true,
          images: WhiteImages.WHorse,
          type: ChessPieceType.Horse);
      // Camel
      newBoard[0][2] = ChessPieces(
          isWhite: false,
          images: BlackImages.BCamel,
          type: ChessPieceType.Camel);
      newBoard[0][5] = ChessPieces(
          isWhite: false,
          images: BlackImages.BCamel,
          type: ChessPieceType.Camel);
      newBoard[7][2] = ChessPieces(
          isWhite: true,
          images: WhiteImages.WCamel,
          type: ChessPieceType.Camel);
      newBoard[7][5] = ChessPieces(
          isWhite: true,
          images: WhiteImages.WCamel,
          type: ChessPieceType.Camel);
      // King
      newBoard[0][4] = ChessPieces(
          isWhite: false, images: BlackImages.BKing, type: ChessPieceType.King);
      newBoard[7][3] = ChessPieces(
          isWhite: true, images: WhiteImages.WKing, type: ChessPieceType.King);
      // Queen
      newBoard[0][3] = ChessPieces(
          isWhite: false,
          images: BlackImages.BQueen,
          type: ChessPieceType.Queen);
      newBoard[7][4] = ChessPieces(
        isWhite: true,
        images: WhiteImages.WQueen,
        type: ChessPieceType.Queen,
      );
    }

    board = newBoard;
  }

//User selected a piece
  void pieceSelected(int row, int col) {
    setState(() {
      //No piece has been selected yet, this is the fist selection
      if (selectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
        }
      }
      //there is piece already selected, but user can select another one of their piece
      else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece!.isWhite) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }
//if there is a piece selected and user taps on a square that is a valid move , move there

      //if a piece is selected, calculate it's valid moves

      else if (selectedPiece != null &&
          validmoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);
      }
      validmoves = calculateRealValidMoves(
          selectedRow, selectedCol, selectedPiece, true);
    });
  }

//calculate raw valid moves
  List<List<int>> calculateValidMoves(int row, int col, ChessPieces? pieces) {
    List<List<int>> candiddateMoves = [];
    if (pieces == null) {
      return [];
    }
    // int direction = pieces!.isWhite ? -1 : 1;
    int direction = pieces.isWhite ? -1 : 1;

    switch (pieces.type) {
      //soldier can move forward if the space is not occupied
      case ChessPieceType.Soldier:
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candiddateMoves.add([row + direction, col]);
        }
//soldier can move 2 squares forward of they are at their initial position
        if ((row == 1 && !pieces.isWhite) || (row == 6 && pieces.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            candiddateMoves.add([row + 2 * direction, col]);
          }
        }
// soldier can kill diagonaly

//whiteeee
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != pieces.isWhite) {
          candiddateMoves.add([row + direction, col - 1]);
        }
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != pieces.isWhite) {
          candiddateMoves.add([row + direction, col + 1]);
        }

        break;
      //elephantttttt
      case ChessPieceType.Elephant:
        var directions = [
          [-1, 0], //up
          [1, 0], // down
          [0, -1], //left

          [0, 1] //right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != pieces.isWhite) {
                candiddateMoves.add([newRow, newCol]);
              }
              break;
            }
            candiddateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.Horse:
        var HorseMoves = [
          [-2, -1],
          [-2, 1],
          [-1, -2],
          [-1, 2],
          [1, -2],
          [1, 2],
          [2, -1],
          [2, 1]
        ];

        for (var move in HorseMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != pieces.isWhite) {
              candiddateMoves.add([newRow, newCol]);
            }
            continue;
          }
          candiddateMoves.add([newRow, newCol]);
        }

        break;
      case ChessPieceType.Camel:
        var directions = [
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1]
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != pieces.isWhite) {
                candiddateMoves.add([newRow, newCol]);
              }
              break;
            }
            candiddateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.King:
        var directions = [
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1],
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1]
        ];
        for (var direction in directions) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != pieces.isWhite) {
              candiddateMoves.add([newRow, newCol]);
            }
            continue;
          }
          candiddateMoves.add([newRow, newCol]);
        }

        break;
      case ChessPieceType.Queen:
        var directions = [
          [-1, 0],
          [1, 0],
          [0, -1],
          [0, 1],
          [-1, -1],
          [-1, 1],
          [1, -1],
          [1, 1]
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != pieces.isWhite) {
                candiddateMoves.add([newRow, newCol]);
              }
              break;
            }
            candiddateMoves.add([newRow, newCol]);
            i++;
          }
        }

        break;
      default:
    }
    return candiddateMoves;
  }
//calculate real valid moves

  List<List<int>> calculateRealValidMoves(
      int row, int col, ChessPieces? pieces, bool checkSimulation) {
    List<List<int>> realValidMoves = [];
    List<List<int>> realCandidateMoves = calculateValidMoves(row, col, pieces);

    if (checkSimulation) {
      for (var move in realCandidateMoves) {
        int endRow = move[0];
        int endCol = move[1];
        if (SimulatedMoveIsSafe(pieces!, row, col, endRow, endCol)) {
          realValidMoves.add(move);
        }
      }
    } else {
      realValidMoves = realCandidateMoves;
    }
    return realValidMoves;
  }

//MOve piece
  void movePiece(int newRow, int newCol) {
    //if the new spot has an enemy piece
    if (board[newRow][newCol] != null) {
      var capturedPiece = board[newRow][newCol];
      if (capturedPiece!.isWhite) {
        whitePiecesTaken.add(capturedPiece);
      } else {
        blackPiecesTaken.add(capturedPiece);
      }
    }

//check if the piece being moves in a king
    if (selectedPiece!.type == ChessPieceType.King) {
      if (selectedPiece!.isWhite) {
        whiteKingPosition = [newRow, newCol];
      } else {
        blackKingPosition = [newRow, newCol];
      }
    }

//move the piece and clear the old spot
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    //see if any kinsgs are under attack
    if (isKingInCheck(!isWhiteTurn)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }

//clear selection

    setState(() {
      selectedPiece = null;

      selectedRow = -1;

      selectedCol = -1;

      validmoves = [];
    });
    /////////////////////////////////////////////////////////////////////////////

    if (isCheckMate(!isWhiteTurn)) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("C H E C K M A T E!"),
                actions: [
                  TextButton(
                      onPressed: resetGame,
                      child: const Text("P L A Y A G A I N"))
                ],
              ));
    }

    isWhiteTurn = !isWhiteTurn;
  }

  bool isKingInCheck(bool isWhiteKing) {
//get the postion of the king

    List<int> kingPostion = isWhiteKing ? whiteKingPosition : blackKingPosition;

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        // skip through the empty squares and pieces of the same color as the king
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }
        List<List<int>> placeValidMoves =
            calculateRealValidMoves(i, j, board[i][j], false);

        //check if the king's postion is in this place's valid moves
        if (placeValidMoves.any(
            (move) => move[0] == kingPostion[0] && move[1] == kingPostion[1])) {
          return true;
        }
      }
    }
    return false;
  }

  bool SimulatedMoveIsSafe(
      ChessPieces pieces, int startRow, int startCol, int endRow, int endCol) {
    ChessPieces? originalDestinationPiece = board[endRow][endCol];

    List<int>? originalKingPosition;
    if (pieces.type == ChessPieceType.King) {
      originalKingPosition =
          pieces.isWhite ? whiteKingPosition : blackKingPosition;
//update the king position
      if (pieces.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }
//simulate the move
    board[endRow][endCol] = pieces;
    board[startRow][startCol] = null;

    //check if hte king is in check

    bool KingInCheck = isKingInCheck(pieces.isWhite);

    board[startRow][startCol] = pieces;
    board[endRow][endCol] = originalDestinationPiece;

    if (pieces.type == ChessPieceType.King) {
      if (pieces.isWhite) {
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }

    return !KingInCheck;
  }

  bool isCheckMate(bool isWhiteKing) {
//if the king is not in check , them it's not checkmate

    if (!isKingInCheck(isWhiteKing)) {
      return false;
    }

    //
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite != isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board[i][j], true);

        if (pieceValidMoves.isNotEmpty) {
          return false;
        }
      }
    }

    return true;
  }

  void resetGame() {
    Navigator.pop(context);
    initializeBoard();
    checkStatus = false;
    whitePiecesTaken.clear();
    blackPiecesTaken.clear();
    whiteKingPosition = [7, 4];
    blackKingPosition = [0, 4];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          return DesktopBoard(
              board,
              selectedRow,
              selectedCol,
              pieceSelected,
              validmoves,
              context,
              blackPiecesTaken,
              whitePiecesTaken,
              checkStatus);
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
          return Container(color: Colors.red);
        }

        if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
          return MobileBoard(board, selectedRow, selectedCol, pieceSelected,
              validmoves, context, whitePiecesTaken, blackPiecesTaken);
        }

        return Container(color: Colors.purple);
      },
    );
  }
}

Widget MobileBoard(
    List<List<ChessPieces?>> board,
    int selectedRow,
    int selectedCol,
    void Function(int, int) pieceSelected,
    validmoves,
    context,
    whitePiecesTaken,
    blackPiecesTaken) {
  return SafeArea(
    child: Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.transparent,
              height: 60,
              width: double.infinity,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 16),
                itemBuilder: (context, index) {
                  return DeadPiece2(
                      chessPiece: whitePiecesTaken.length > index
                          ? whitePiecesTaken[index]
                          : null);
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                  border: Border.all(
                      color: Colors.white, width: 2, style: BorderStyle.solid)),
              height: 355,
              width: double.infinity,
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 8 * 8,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8),
                  itemBuilder: (context, index) {
                    int row = index ~/ 8;
                    int column = index % 8;
                    bool isSelected =
                        selectedRow == row && selectedCol == column;

                    bool isValidmove = false;
                    for (var position in validmoves) {
                      if (position[0] == row && position[1] == column) {
                        isValidmove = true;
                      }
                    }
                    return Squares(
                      onTap: () => pieceSelected(row, column),
                      isSelected: isSelected,
                      isWhite: isWhite(index),
                      pieces: board[row][column],
                      isValidMove: isValidmove,
                    );
                  }),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              color: Colors.transparent,
              height: 60,
              width: double.infinity,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 16),
                itemBuilder: (context, index) {
                  return DeadPiece2(
                      chessPiece: blackPiecesTaken.length > index
                          ? blackPiecesTaken[index]
                          : null);
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget DesktopBoard(
    List<List<ChessPieces?>> board,
    int selectedRow,
    int selectedCol,
    void Function(int, int) pieceSelected,
    validmoves,
    context,
    blackPiecesTaken,
    whitePiecesTaken,
    checkStatus) {
  return SafeArea(
    child: Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(left: 50, top: 18, bottom: 18),
        child: Row(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        border: Border.all(
                            color: Colors.white,
                            width: 2,
                            style: BorderStyle.solid)),
                    height: MediaQuery.of(context).size.height * 0.5 + 330,
                    width: 700,
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 8 * 8,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 8),
                        itemBuilder: (context, index) {
                          int row = index ~/ 8;
                          int column = index % 8;
                          bool isSelected =
                              selectedRow == row && selectedCol == column;

                          bool isValidmove = false;
                          for (var position in validmoves) {
                            if (position[0] == row && position[1] == column) {
                              isValidmove = true;
                            }
                          }
                          return Squares(
                            onTap: () => pieceSelected(row, column),
                            isSelected: isSelected,
                            isWhite: isWhite(index),
                            pieces: board[row][column],
                            isValidMove: isValidmove,
                          );
                        }),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      color: Colors.transparent,
                      height: 360,
                      width: 200,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          return DeadPiece(
                              chessPiece: whitePiecesTaken.length > index
                                  ? whitePiecesTaken[index]
                                  : null);
                        },
                      ),
                    ),
                  ],
                ),
                Text(
                  checkStatus ? "C H E C K" : "",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        color: Colors.transparent,
                        height: 350,
                        width: 200,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: (context, index) {
                            return DeadPiece(
                                chessPiece: blackPiecesTaken.length > index
                                    ? blackPiecesTaken[index]
                                    : null);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
