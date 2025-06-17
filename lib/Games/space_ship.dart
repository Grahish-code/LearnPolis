import 'package:flutter/material.dart';

class SpaceRacingGame extends StatefulWidget {
  const SpaceRacingGame({Key? key}) : super(key: key);

  @override
  State<SpaceRacingGame> createState() => _SpaceRacingGameState();
}

class _SpaceRacingGameState extends State<SpaceRacingGame> with TickerProviderStateMixin {
  double _spaceshipX = 150; // Initial X position of the spaceship
  double _spaceshipY = 300; // Initial Y position of the spaceship
  int _score = 0;
  int _fuel = 100; // Fuel level
  int _currentQuestion = 0;
  bool _isGameOver = false;

  final List<Question> _questions = [
    Question(
      question: "What is the closest star to Earth?",
      options: ["Proxima Centauri", "Sun", "Alpha Centauri", "Betelgeuse"],
      correct: 1,
    ),
    Question(
      question: "Which planet has the most moons?",
      options: ["Jupiter", "Saturn", "Mars", "Neptune"],
      correct: 1,
    ),
    Question(
      question: "What is the largest galaxy in the universe?",
      options: ["Milky Way", "Andromeda", "IC 1101", "Triangulum"],
      correct: 2,
    ),
    Question(
      question: "What is the speed of light?",
      options: ["300,000 km/s", "150,000 km/s", "450,000 km/s", "600,000 km/s"],
      correct: 0,
    ),
  ];

  final List<Asteroid> _asteroids = [
    Asteroid(x: 200, y: -50, speed: 2),
    Asteroid(x: 400, y: -100, speed: 3),
    Asteroid(x: 600, y: -150, speed: 4),
  ];

  @override
  void initState() {
    super.initState();
    _startAsteroidMovement();
  }

  void _startAsteroidMovement() {
    Future.doWhile(() async {
      if (_isGameOver) return false; // Stop the loop if the game is over

      setState(() {
        for (var asteroid in _asteroids) {
          asteroid.y += asteroid.speed; // Move asteroids downward
          if (asteroid.y > 600) {
            // Reset asteroid position if it goes off-screen
            asteroid.y = -50;
            asteroid.x = (100 + asteroid.x * 1.5) % 400;
          }

          // Check for collision
          if ((_spaceshipX - asteroid.x).abs() < 50 && (_spaceshipY - asteroid.y).abs() < 50) {
            _fuel -= 20; // Reduce fuel on collision
            if (_fuel <= 0) {
              _isGameOver = true;
              _showGameOverDialog();
            }
          }
        }
      });

      await Future.delayed(const Duration(milliseconds: 50));
      return true;
    });
  }

  void _checkAnswer(int option) {
    if (_isGameOver) return;

    if (option == _questions[_currentQuestion].correct) {
      setState(() {
        _score += 10;
        _fuel = (_fuel + 20).clamp(0, 100); // Refill fuel on correct answer
        _currentQuestion = (_currentQuestion + 1) % _questions.length;
      });
    } else {
      setState(() {
        _fuel -= 30; // Drain fuel on incorrect answer
        if (_fuel <= 0) {
          _isGameOver = true;
          _showGameOverDialog();
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect answer. Fuel drained!')),
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
      _spaceshipX = 150;
      _spaceshipY = 300;
      _score = 0;
      _fuel = 100;
      _currentQuestion = 0;
      _isGameOver = false;
    });
    _startAsteroidMovement();
  }

  void _triggerQuiz() {
    if (_isGameOver) return;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Space Racing Game'),
      ),
      body: Column(
        children: [
          // Game area
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/games/SpaceShip/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Spaceship
                  Positioned(
                    left: _spaceshipX,
                    top: _spaceshipY,
                    child: Image.asset('assets/games/SpaceShip/space_ship.png', width: 50, height: 50),
                  ),
                  // Asteroids
                  ..._asteroids.map((asteroid) {
                    return Positioned(
                      left: asteroid.x,
                      top: asteroid.y,
                      child: Image.asset('assets/games/SpaceShip/asteroid.jpg', width: 40, height: 40),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          // Controls and quiz interface
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Fuel: $_fuel%', style: const TextStyle(fontSize: 20)),
                  Text('Score: $_score', style: const TextStyle(fontSize: 20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => setState(() => _spaceshipY = (_spaceshipY - 20).clamp(0, 550)),
                        child: const Text('Up'),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() => _spaceshipY = (_spaceshipY + 20).clamp(0, 550)),
                        child: const Text('Down'),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() => _spaceshipX = (_spaceshipX - 20).clamp(0, 350)),
                        child: const Text('Left'),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() => _spaceshipX = (_spaceshipX + 20).clamp(0, 350)),
                        child: const Text('Right'),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _triggerQuiz,
                    child: const Text('Answer Quiz'),
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

class Asteroid {
  double x;
  double y;
  final double speed;

  Asteroid({required this.x, required this.y, required this.speed});
}