import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

enum StateType { x, o, empty }

enum GameState { xWin, oWin, draw, active }

class TicTacPage extends StatefulWidget {
  const TicTacPage({super.key});

  @override
  State<TicTacPage> createState() => _TicTacPageState();
}

class _TicTacPageState extends State<TicTacPage> {
  List<List<StateType>> boardState = [];
  int turn = 1;
  GameState currentGameState = GameState.active;
  bool isLoading = false;

  play(int positionI, int positionJ) {
    if (turn % 2 == 1) {
      setState(() {
        boardState[positionI][positionJ] = StateType.o;
      });
    } else {
      setState(() {
        boardState[positionI][positionJ] = StateType.x;
      });
    }
    // checkWinOrLoss
    setState(() {
      turn++;
    });
    GameState currentGameState = checkGameState();
    if (currentGameState == GameState.draw) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Draw'),
              content: Text('The game was a draw'),
              actions: [
                TextButton(
                  child: const Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    reset();
                  },
                ),
              ],
            );
          });
    } else if (currentGameState == GameState.oWin) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Game Over'),
              content: Text('Player \'o\' has won the game'),
              actions: [
                TextButton(
                  child: const Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    reset();
                  },
                ),
              ],
            );
          });
    } else if (currentGameState == GameState.xWin) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Game Over'),
              content: Text('Player \'x\' has won the game'),
              actions: [
                TextButton(
                  child: const Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    reset();
                  },
                ),
              ],
            );
          });
    }
  }

  reset() {
    setState(() {
      turn = 1;
    });
    initBoardState();
  }

  GameState checkGameState() {
    if (getEmptyPlaces().isEmpty) {
      return GameState.draw;
    } else {
      if (boardState[0][0] == boardState[0][1] &&
          boardState[0][1] == boardState[0][2]) {
        if (boardState[0][0] == StateType.x) {
          return GameState.xWin;
        } else if (boardState[0][0] == StateType.o) {
          return GameState.oWin;
        }
      } else if (boardState[0][0] == boardState[1][0] &&
          boardState[1][0] == boardState[2][0]) {
        if (boardState[0][0] == StateType.x) {
          return GameState.xWin;
        } else if (boardState[0][0] == StateType.o) {
          return GameState.oWin;
        }
      } else if (boardState[2][0] == boardState[2][1] &&
          boardState[2][1] == boardState[2][2]) {
        if (boardState[2][0] == StateType.x) {
          return GameState.xWin;
        } else if (boardState[2][0] == StateType.o) {
          return GameState.oWin;
        }
      } else if (boardState[0][2] == boardState[1][2] &&
          boardState[1][2] == boardState[2][2]) {
        if (boardState[0][2] == StateType.x) {
          return GameState.xWin;
        } else if (boardState[0][2] == StateType.o) {
          return GameState.oWin;
        }
      } else if (boardState[0][1] == boardState[1][1] &&
          boardState[1][1] == boardState[2][1]) {
        if (boardState[0][1] == StateType.x) {
          return GameState.xWin;
        } else if (boardState[0][1] == StateType.o) {
          return GameState.oWin;
        }
      } else if (boardState[1][0] == boardState[1][1] &&
          boardState[1][1] == boardState[1][2]) {
        if (boardState[1][0] == StateType.x) {
          return GameState.xWin;
        } else if (boardState[1][0] == StateType.o) {
          return GameState.oWin;
        }
      } else if (boardState[0][0] == boardState[1][1] &&
          boardState[1][1] == boardState[2][2]) {
        if (boardState[0][0] == StateType.x) {
          return GameState.xWin;
        } else if (boardState[0][0] == StateType.o) {
          return GameState.oWin;
        }
      } else if (boardState[0][2] == boardState[1][1] &&
          boardState[1][1] == boardState[2][0]) {
        if (boardState[0][2] == StateType.x) {
          return GameState.xWin;
        } else if (boardState[0][2] == StateType.o) {
          return GameState.oWin;
        }
      }
      return GameState.active;
    }
  }

  List<List<int>> getEmptyPlaces() {
    List<List<int>> emptyPlaces = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (boardState[i][j] == StateType.empty) {
          emptyPlaces.add([i, j]);
        }
      }
    }
    return emptyPlaces;
  }

  initBoardState() {
    setState(() {
      boardState = [];
    });
    for (int i = 0; i < 3; i++) {
      List<StateType> temp = [];
      for (int j = 0; j < 3; j++) {
        temp.add(StateType.empty);
      }
      setState(() {
        boardState.add(temp);
      });
    }
    print('Board state init: $boardState');
  }

  computerPlay() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    List<List<int>> possibleMoves = getEmptyPlaces();
    int bestScore = -500000000;
    List<int>? bestMove = null;
    for (int move = 0; move < possibleMoves.length; move++) {
      setState(() {
        boardState[possibleMoves[move][0]][possibleMoves[move][1]] =
            StateType.x;
      });

      int score = minimax(boardState, 0, false);
      setState(() {
        boardState[possibleMoves[move][0]][possibleMoves[move][1]] =
            StateType.empty;
      });
      if (score > bestScore) {
        bestScore = score;
        bestMove = possibleMoves[move];
      }
    }
    if (bestMove != null) play(bestMove[0], bestMove[1]);

    setState(() {
      isLoading = false;
    });
  }

  Map<GameState, int> scores = {
    GameState.xWin: 1,
    GameState.oWin: -1,
    GameState.draw: 0
  };

  int minimax(List<List<StateType>> board, int depth, bool isMaximizing) {
    GameState gameState = checkGameState();
    if (gameState != GameState.active) {
      int score = scores[gameState] ?? 0;
      print('Score: $score');
      return score;
    }
    if (isMaximizing) {
      int bestScore = -500000000;
      List<List<int>> possibleMoves = getEmptyPlaces();
      for (int move = 0; move < possibleMoves.length; move++) {
        setState(() {
          boardState[possibleMoves[move][0]][possibleMoves[move][1]] =
              StateType.x;
        });

        int score = minimax(boardState, depth + 1, false);
        setState(() {
          boardState[possibleMoves[move][0]][possibleMoves[move][1]] =
              StateType.empty;
        });
        if (score > bestScore) {
          bestScore = score;
        }
      }
      return bestScore;
    } else {
      int bestScore = 500000000;
      List<List<int>> possibleMoves = getEmptyPlaces();
      for (int move = 0; move < possibleMoves.length; move++) {
        setState(() {
          boardState[possibleMoves[move][0]][possibleMoves[move][1]] =
              StateType.o;
        });

        int score = minimax(boardState, depth + 1, true);
        setState(() {
          boardState[possibleMoves[move][0]][possibleMoves[move][1]] =
              StateType.empty;
        });
        if (score < bestScore) {
          bestScore = score;
        }
      }
      return bestScore;
    }
  }

  @override
  void initState() {
    initBoardState();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Tic Tac Toe',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              height: 50,
              child: Visibility(
                  visible: isLoading, child: const CircularProgressIndicator()),
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.width * 0.9,
                child: Stack(children: [
                  Image.asset(
                    'assets/background.png',
                    color: Colors.white,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(boardState.length, (i) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            boardState[i].length,
                            (j) {
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  if (turn % 2 == 1 && !isLoading) {
                                    play(i, j);
                                    if (checkGameState() == GameState.active)
                                      computerPlay();
                                  }
                                },
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.9 *
                                      0.3,
                                  height: MediaQuery.of(context).size.width *
                                      0.9 *
                                      0.3,
                                  child: boardState[i][j] == StateType.empty
                                      ? Container()
                                      : Center(
                                          child: Text(
                                          boardState[i][j] == StateType.x
                                              ? 'x'
                                              : 'o',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2),
                                        )),
                                ),
                              );
                            },
                          ));
                    }),
                  )
                ]),
              ),
            ),
          ]),
      backgroundColor: const Color(0xFF555555),
    );
  }
}
