import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tech_quest/loginPage.dart';


class ProfilePage extends StatelessWidget {
  final String username;


  const ProfilePage({super.key, required this.username});

  // Function to handle logout
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()), // Replace with your LoginPage
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF030411),
              Color(0xFF0F143A),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Center(child: ProfileImage()),
                const SizedBox(height: 4),
                Center(child: ProfileName(username: username)),
                const SizedBox(height: 2),
                const Center(child: ProfileDetails()),
                const SizedBox(height: 4),
                const LevelContainer(),
                const Padding(
                  padding: EdgeInsets.only(left: 12.0, top: 14.0, bottom: 7),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Achievements',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                const AchievementIcons(),
                const Padding(
                  padding: EdgeInsets.only(left: 12.0, top: 14.0, bottom: 7),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Current Courses',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                const CurrentCourses(),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 12.0, top: 14.0, bottom: 7),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Learning Stats',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                const LearningStats(),
                const SizedBox(height: 20),
                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () => _logout(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 28, 33, 66),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 140,
        height: 90,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}

class ProfileName extends StatelessWidget {
  final String username;

  const ProfileName({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        username,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 23,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'AI & ML Enthusiast',
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 18,
        ),
      ),
    );
  }
}

class LevelContainer extends StatelessWidget {
  const LevelContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 20, 23, 40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF303349),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              'Level 15',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    '2,450',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Total Score',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '#234',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Global Rank',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '12',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Courses',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AchievementIcons extends StatelessWidget {
  const AchievementIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AchievementItem(icon: Icons.star, label: 'Top Learner', color: Colors.amber),
            AchievementItem(icon: Icons.rocket, label: 'Fast Learner', color: Colors.pinkAccent),
            AchievementItem(icon: Icons.book, label: 'Bookworm', color: Colors.blueAccent),
            AchievementItem(icon: Icons.bar_chart, label: 'Consistent', color: Colors.greenAccent),
          ].map((item) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: item,
          )).toList(),
        ),
      ),
    );
  }
}

class AchievementItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const AchievementItem({super.key, required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF121428),
          ),
          child: Icon(icon, color: color, size: 30),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class CurrentCourses extends StatelessWidget {
  const CurrentCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          CourseItem(title: 'UX Design Fundamentals', progress: 0.75),
          const SizedBox(height: 10),
          CourseItem(title: 'Web Development', progress: 0.45),
          const SizedBox(height: 10),
          CourseItem(title: 'Digital Marketing', progress: 0.90),
        ],
      ),
    );
  }
}

class CourseItem extends StatelessWidget {
  final String title;
  final double progress;

  const CourseItem({super.key, required this.title, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 28, 33, 66),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[700],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                Text(
                  '${(progress * 100).round()}% Complete',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LearningStats extends StatelessWidget {
  const LearningStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: const [
          StatsCard(icon: Icons.local_fire_department, value: '5 Days', label: 'Study Streak'),
          StatsCard(icon: Icons.access_time, value: '48 Hours', label: 'Hours Learned'),
          StatsCard(icon: Icons.verified_user, value: '3 Earned', label: 'Certificates'),
          StatsCard(icon: Icons.star, value: '92% Avg', label: 'Quiz Score'),
        ],
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const StatsCard({super.key, required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 28, 33, 66),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.greenAccent, size: 28),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}