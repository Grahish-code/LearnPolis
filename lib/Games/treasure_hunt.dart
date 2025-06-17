import 'package:flutter/material.dart';

class TreasureHuntGame extends StatefulWidget {
  const TreasureHuntGame({Key? key}) : super(key: key);

  @override
  State<TreasureHuntGame> createState() => _TreasureHuntGameState();
}

class _TreasureHuntGameState extends State<TreasureHuntGame> {
  int _playerX = 1; // Player's X position on the grid
  int _playerY = 1; // Player's Y position on the grid
  int _score = 0;
  int _health = 100; // Player's health
  bool _isGameOver = false;

  final List<Question> _questions = [
    Question(
      question: "What is the capital of Australia?",
      options: ["Sydney", "Melbourne", "Canberra", "Brisbane"],
      correct: 2,
    ),
    Question(
      question: "Which animal is known as the 'King of the Jungle'?",
      options: ["Lion", "Tiger", "Elephant", "Gorilla"],
      correct: 0,
    ),
    Question(
      question: "What is the largest ocean on Earth?",
      options: ["Atlantic", "Indian", "Arctic", "Pacific"],
      correct: 3,
    ),
    Question(
      question: "Who discovered gravity?",
      options: ["Albert Einstein", "Isaac Newton", "Galileo Galilei", "Nikola Tesla"],
      correct: 1,
    ),
  ];

  final List<TreasureChest> _treasureChests = [
    TreasureChest(x: 2, y: 2, questionIndex: 0),
    TreasureChest(x: 3, y: 4, questionIndex: 1),
    TreasureChest(x: 5, y: 3, questionIndex: 2),
    TreasureChest(x: 4, y: 1, questionIndex: 3),
  ];

  final List<Trap> _traps = [
    Trap(x: 1, y: 3),
    Trap(x: 4, y: 4),
    Trap(x: 5, y: 1),
  ];

  void _movePlayer(int deltaX, int deltaY) {
    if (_isGameOver) return;

    setState(() {
      _playerX = (_playerX + deltaX).clamp(1, 5);
      _playerY = (_playerY + deltaY).clamp(1, 5);

      // Check for treasure chests
      for (var chest in _treasureChests) {
        if (_playerX == chest.x && _playerY == chest.y && !chest.isOpened) {
          _triggerQuiz(chest);
          return;
        }
      }

      // Check for traps
      for (var trap in _traps) {
        if (_playerX == trap.x && _playerY == trap.y) {
          _health -= 20;
          if (_health <= 0) {
            _isGameOver = true;
            _showGameOverDialog();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You triggered a trap! Health reduced.')),
            );
          }
          return;
        }
      }
    });
  }

  void _triggerQuiz(TreasureChest chest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Time!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_questions[chest.questionIndex].question),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              children: List.generate(
                4,
                    (index) => ElevatedButton(
                  onPressed: () {
                    _checkAnswer(index, chest);
                    Navigator.of(context).pop();
                  },
                  child: Text(_questions[chest.questionIndex].options[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkAnswer(int option, TreasureChest chest) {
    if (_isGameOver) return;

    if (option == _questions[chest.questionIndex].correct) {
      setState(() {
        _score += 10;
        _health = (_health + 10).clamp(0, 100); // Restore health
        chest.isOpened = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correct answer! Treasure unlocked.')),
      );
    } else {
      setState(() {
        _health -= 20; // Reduce health on incorrect answer
        if (_health <= 0) {
          _isGameOver = true;
          _showGameOverDialog();
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect answer. Health reduced!')),
      );
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Your final score is $_score. Better luck next time!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _playerX = 1;
      _playerY = 1;
      _score = 0;
      _health = 100;
      _isGameOver = false;
      for (var chest in _treasureChests) {
        chest.isOpened = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treasure Hunt Adventure'),
      ),
      body: Column(
        children: [
          // Game grid
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/games/treasure_hunt/img_2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                ),
                itemCount: 25,
                itemBuilder: (context, index) {
                  int x = (index % 5) + 1;
                  int y = (index ~/ 5) + 1;
                  bool isPlayer = x == _playerX && y == _playerY;
                  bool isTreasure = _treasureChests.any((chest) => chest.x == x && chest.y == y && !chest.isOpened);
                  bool isTrap = _traps.any((trap) => trap.x == x && trap.y == y);

                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: isPlayer
                          ? Image.asset('assets/games/treasure_hunt/character.jpg', width: 40, height: 40)
                          : isTreasure
                          ? Image.asset('assets/games/treasure_hunt/img.png', width: 40, height: 40)
                          : isTrap
                          ? Image.asset('assets/games/treasure_hunt/img_1.png', width: 40, height: 40)
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
          // Controls and stats
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Health: $_health%', style: const TextStyle(fontSize: 20)),
                  Text('Score: $_score', style: const TextStyle(fontSize: 20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _movePlayer(-1, 0),
                        child: const Text('Left'),
                      ),
                      ElevatedButton(
                        onPressed: () => _movePlayer(1, 0),
                        child: const Text('Right'),
                      ),
                      ElevatedButton(
                        onPressed: () => _movePlayer(0, -1),
                        child: const Text('Up'),
                      ),
                      ElevatedButton(
                        onPressed: () => _movePlayer(0, 1),
                        child: const Text('Down'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Question {
  final String question;
  final List<String> options;
  final int correct;

  Question({
    required this.question,
    required this.options,
    required this.correct,
  });
}

class TreasureChest {
  final int x;
  final int y;
  final int questionIndex;
  bool isOpened = false;

  TreasureChest({
    required this.x,
    required this.y,
    required this.questionIndex,
  });
}

class Trap {
  final int x;
  final int y;

  Trap({
    required this.x,
    required this.y,
  });
}