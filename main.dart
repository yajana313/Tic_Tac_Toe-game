import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      home: TicTacToePage(),
    );
  }
}

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key});
  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  List<String> moves = List.filled(9, "-");
  String currentPlayer = "X";
  int count = 0;
  int xScore = 0;
  int oScore = 0;
  @override
  Widget build(BuildContext context) {
    Size screensize = MediaQuery.of(context).size;
    double gridside = screensize.width * 0.8;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade200],
            begin: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "current Move:$currentPlayer",
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Score-X:$xScore | O:$oScore",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: gridside,
              width: gridside,
              child: GridView.builder(
                primary: false,
                padding: const EdgeInsets.all(8),
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (moves[index] == "-") {
                        setState(() {
                          moves[index] = currentPlayer;
                          count++;
                          if (_checkWinner()) {
                            _updateScore();
                            _showDialog(
                              context,
                              "Winner!",
                              "The Winner is $currentPlayer",
                            );
                          } else if (count == 9) {
                            _showDialog(context, "Draw!", "The Match is Draw");
                          }
                          currentPlayer = currentPlayer == "O" ? "X" : "O";
                        });
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        color:
                            moves[index] == "-"
                                ? Colors.white
                                : moves[index] == "X"
                                ? Colors.blue.shade100
                                : Colors.red.shade100,
                      ),

                      // borderRadius: BorderRadius.circular(10),
                      child: Center(
                        child: Text(
                          moves[index],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetGame,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text("Reset Game"),
            ),
          ],
        ),
      ),
    );
  }

  void _resetGame() {
    setState(() {
      moves = List.filled(9, "-");
      currentPlayer = "X";
      count = 0;
    });
  }

  bool _checkWinner() {
    List<List<int>> winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var combo in winningCombinations) {
      if (moves[combo[0]] != "-" &&
          moves[combo[0]] == moves[combo[1]] &&
          moves[combo[1]] == moves[combo[2]]) {
        return true;
      }
    }
    return false;
  }

  void _updateScore() {
    if (currentPlayer == "X") {
      xScore++;
    } else {
      oScore++;
    }
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: const Text("Play Again"),
            ),
          ],
        );
      },
    );
  }
}
