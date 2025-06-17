import 'package:flutter/material.dart';
import 'package:tech_quest/Games/mario.dart';
import 'package:tech_quest/Games/space_ship.dart';
import 'package:tech_quest/Games/treasure_hunt.dart';


class ChallengePage extends StatelessWidget {
  const ChallengePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF13192F), // Set background color to black
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Level 8',
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)), // Text color is white
                        Text('Silver Scholar',
                            style: const TextStyle(fontSize: 16, color: Colors.white70)), // Text color is white70
                      ],
                    ),
                    Text('#7 Your Rank',
                        style: const TextStyle(fontSize: 16, color: Colors.white)), // Text color is white
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCategoryTab('Coding', isActive: true),
                    _buildCategoryTab('Web Dev'),
                    _buildCategoryTab('Math'),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 700, // Increased height for more space
                  child: SingleChildScrollView(
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                      crossAxisCount: 2, // 2 columns
                      crossAxisSpacing: 16, // Spacing between columns
                      mainAxisSpacing: 16, // Spacing between rows
                      childAspectRatio: 0.75, // Adjusted aspect ratio for better layout
                      children: [
                        _buildGameCard('Mario', 'Coding', 'assets/mario_img.png', context),
                        _buildGameCard('Space Race', 'Web Dev', 'assets/spaceship_logo.png', context),
                        _buildGameCard('Treasure Hunt', 'Math', 'assets/treasure_hunt.jpg', context),
                        _buildGameCard('Puzzle', 'Logic', 'assets/puzzle.png', context),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Leaderboard',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)), // Text color is white
                const SizedBox(height: 10),
                Column(
                  children: [
                    _buildLeaderboardItem('User1', '14,350', 1),
                    _buildLeaderboardItem('User2', '15,780', 2),
                    _buildLeaderboardItem('User3', '13,920', 3),
                  ],
                ),
                const SizedBox(height: 10),
                Text('Your Rank: 9',
                    style: const TextStyle(fontSize: 16, color: Colors.white70)), // Text color is white70
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String category, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
        border: isActive ? Border.all(color: Colors.blue, width: 2) : null,
      ),
      child: Text(category,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), // Text color is white
    );
  }



  Widget _buildGameCard(String gameName, String domain, String imagePath, BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.purple.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      imagePath,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  gameName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  domain,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the respective game page
                    Widget gamePage;
                    switch (gameName) {
                      case 'Mario':
                        gamePage = QuizGame();
                        break;
                      case 'Space Race':
                        gamePage = SpaceRacingGame();
                        break;
                      case 'Treasure Hunt':
                        gamePage = TreasureHuntGame();
                        break;
                      case 'Puzzle':
                        gamePage = QuizGame();
                        break;
                      default:
                        gamePage = Scaffold(
                          appBar: AppBar(title: Text(gameName)),
                          body: Center(child: Text('Coming Soon!')),
                        );
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => gamePage),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Play',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildLeaderboardItem(String userName, String score, int rank) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        child: Text(
          rank.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(userName, style: const TextStyle(color: Colors.white)), // Text color is white
      trailing: Text(score, style: const TextStyle(color: Colors.white70)), // Text color is white70
    );
  }
}
