import 'package:flutter/material.dart';

class QuizGame extends StatefulWidget {
  const QuizGame({Key? key}) : super(key: key);

  @override
  State<QuizGame> createState() => _QuizGameState();
}

class _QuizGameState extends State<QuizGame> with TickerProviderStateMixin {
  late AnimationController _jumpController;
  late Animation<double> _jumpAnimation;
  late Animation<double> _moveAnimation;

  double _playerPosition = 50; // Initial player position
  int _score = 0;
  int _currentObstacle = 0; // Start at the first obstacle
  int _currentQuestion = 0;
  bool _isGameOver = false; // Track if the game is over

  final ScrollController _scrollController = ScrollController();

  List<Question> _questions = [
    Question(
      question: "What is the capital of India?",
      options: ["Mumbai", "Delhi", "Kolkata", "Chennai"],
      correct: 1,
    ),
    Question(
      question: "What is the largest planet in our solar system?",
      options: ["Earth", "Saturn", "Jupiter", "Uranus"],
      correct: 2,
    ),
    Question(
      question: "Who painted the Mona Lisa?",
      options: ["Leonardo da Vinci", "Michelangelo", "Raphael", "Caravaggio"],
      correct: 0,
    ),
    Question(
      question: "What is the chemical symbol for gold?",
      options: ["Ag", "Au", "Hg", "Pb"],
      correct: 1,
    ),
  ];

  List<Obstacle> _obstacles = [
    Obstacle(xPosition: 300), // Adjusted positions
    Obstacle(xPosition: 600),
    Obstacle(xPosition: 900),
    Obstacle(xPosition: 1200),
  ];

  @override
  void initState() {
    super.initState();
    _jumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Jump animation (parabolic motion: up and down)
    _jumpAnimation = Tween<double>(begin: 0, end: -150).animate(
      CurvedAnimation(
        parent: _jumpController,
        curve: Curves.easeInOut,
      ),
    );

    // Move animation (horizontal movement)
    _moveAnimation = Tween<double>(begin: 0, end: 250).animate(
      CurvedAnimation(
        parent: _jumpController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _checkAnswer(int option) {
    if (_isGameOver) return; // Prevent actions if the game is over

    if (option == _questions[_currentQuestion].correct) {
      setState(() {
        _score++;
        _currentQuestion++;
      });
      _jumpAndMove();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect answer. Try again!')),
      );
    }

    if (_currentQuestion >= _questions.length) {
      _showGameOverDialog();
    }
  }

  void _jumpAndMove() {
    if (_isGameOver) return; // Prevent actions if the game is over

    _jumpController.forward(from: 0).then((_) {
      setState(() {
        // Move player ahead of the obstacle
        _playerPosition = _obstacles[_currentObstacle].xPosition + 100;
        _currentObstacle++;
        _scrollToNextObstacle();
      });
      _jumpController.reverse(); // Bring the player back down
    });
  }

  void _showGameOverDialog() {
    setState(() {
      _isGameOver = true; // Mark the game as over
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Congratulations! You\'ve cleared all obstacles with a score of $_score.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame(); // Reset the game state
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _score = 0;
      _currentObstacle = 0;
      _currentQuestion = 0;
      _playerPosition = 50;
      _isGameOver = false; // Reset game over state
    });
    _scrollController.jumpTo(0); // Reset scroll position
  }

  void _triggerQuiz() {
    if (_isGameOver) return; // Prevent actions if the game is over

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Time!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_questions[_currentQuestion].question),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              children: List.generate(
                4,
                    (index) => ElevatedButton(
                  onPressed: () {
                    _checkAnswer(index);
                    Navigator.of(context).pop();
                  },
                  child: Text(_questions[_currentQuestion].options[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToNextObstacle() {
    if (_currentObstacle < _obstacles.length) {
      _scrollController.animateTo(
        _obstacles[_currentObstacle].xPosition - 200,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Game'),
      ),
      body: Column(
        children: [
          // Game area
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/games/mario/background.jpg'), // Set your background image here
                  fit: BoxFit.cover, // Ensure the image covers the entire area
                ),
              ),
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 2000, // Total width of the scrollable area
                  child: Stack(
                    children: [
                      // Obstacles
                      ..._obstacles.map((obstacle) {
                        return Positioned(
                          left: obstacle.xPosition,
                          top: 315, // Adjusted to align with the land
                          child: Image.asset(
                            'assets/games/mario/obstacle1.png',
                            width: 50,
                            height: 50,
                          ),
                        );
                      }).toList(),
                      // Player
                      AnimatedBuilder(
                        animation: _jumpController,
                        builder: (context, child) {
                          return Positioned(
                            top: 315 + _jumpAnimation.value, // Adjusted to align with the land
                            left: _playerPosition + _moveAnimation.value,
                            child: Image.asset(
                              'assets/games/mario/mario.png',
                              width: 50,
                              height: 50,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Quiz interface
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _isGameOver
                        ? null // Disable button if the game is over
                        : () {
                      // Stop player before the obstacle
                      if (_currentObstacle < _obstacles.length &&
                          _playerPosition + 50 >= _obstacles[_currentObstacle].xPosition - 50) {
                        _triggerQuiz();
                      } else {
                        setState(() {
                          _playerPosition += 100; // Move player forward
                        });
                        _scrollController.animateTo(
                            _playerPosition,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut
                        );
                      }
                    },
                    child: const Text('Move Forward'),
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

class Obstacle {
  final double xPosition;

  Obstacle({
    required this.xPosition,
  });
}