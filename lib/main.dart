import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_quest/Courses.dart'; // Ensure this import is correct
import 'package:tech_quest/Registration_page.dart'; // Ensure this import is correct
import 'package:tech_quest/loginPage.dart'; // Ensure this import is correct
import 'course_provider.dart'; // Import the CourseProvider
import 'Challenge_page.dart';
import 'question_playlist_page.dart'; // Import the updated QuestionPlaylistPage
import 'chat_bot.dart';
import 'package:tech_quest/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await Firebase.initializeApp(); // <-- Initialize Firebase here
  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(), // Provide the CourseProvider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(), // Start with the LoginPage
      routes: {
        '/dashboard': (context) => const DashboardPage(username: 'Alex Mitchell'), // Pass the username here
      },
    );
  }
}

class DashboardPage extends StatefulWidget {
  final String username; // Add a username parameter

  const DashboardPage({super.key, required this.username}); // Update the constructor

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  // List of pages to display in the bottom navigation bar
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    // Initialize the pages with the username
    _pages.addAll([
      DashboardContent(username: widget.username), // Pass the username to DashboardContent
      const LearningPage(),
      const ChallengePage(),
      ChatScreen(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display the current page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E2746),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index); // Update the selected index
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Challenges'),
          BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'ChatBot'),
        ],
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  final String username; // Add a username parameter

  const DashboardContent({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);

    // Filter courses with progress > 0
    final List<Map<String, dynamic>> continueLearningCourses = [
      {
        'title': 'Coding in Java',
        'subtitle': 'Continue where you left off',
        'progress': courseProvider.getCompletionProgress('PLfqMhTWNBTe3LtFWcvwpqTkUSlB32kJop') ?? 0.0, // Use null-aware operator
      },
      {
        'title': 'Engineering Mathematics',
        'subtitle': 'Continue where you left off',
        'progress': courseProvider.getCompletionProgress('PLvTTv60o7qj_tdY9zH7YceES7jfXiZkAz') ?? 0.0, // Use null-aware operator
      },
    ].where((course) => (course['progress'] as double) > 0).toList(); // Ensure progress is not null

    return Scaffold(
      backgroundColor: const Color(0xFF121829),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to ProfilePage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(username: username,), // Pass the username to ProfilePage
                          ),
                        );
                      },
                      child: const CircleAvatar(
                        radius: 30,
                        //backgroundImage: AssetImage('assets/FRAME.png'), // Replace with actual image URL
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username, // Use the username here
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                        ),
                        Text(
                          'Level 15 Engineer',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      '2,450 XP',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.grey),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
                const SizedBox(height: 5),
                const CustomProgressBar(value: 0.7), // Assuming 70%
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '3,000 XP',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Stats Grid
                GridView.count(
                  crossAxisCount: 2, // 2 columns
                  crossAxisSpacing: 10, // Horizontal space between cards
                  mainAxisSpacing: 10, // Vertical space between cards
                  shrinkWrap: true, // To make GridView work inside SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(), // Disable GridView's scrolling
                  children: const [
                    DashboardCard(
                      icon: Icons.local_fire_department,
                      title: '15',
                      subtitle: 'Days Streak',
                    ),
                    DashboardCard(
                      icon: Icons.insert_chart,
                      title: '70%',
                      subtitle: 'Week Goal',
                    ),
                    DashboardCard(
                      icon: Icons.emoji_events,
                      title: 'Top 5%',
                      subtitle: 'Global Rank',
                    ),
                    DashboardCard(
                      icon: Icons.military_tech,
                      title: '24/50',
                      subtitle: 'Achievements',
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Solve Questions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Solve Questions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 10),

                SizedBox(
                  height: 200, // Fixed height for the horizontal scroll view
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: const [
                        ChallengeCard(
                          icon: Icons.code,
                          title: 'Web Master',
                          subtitle: '2/5 completed',
                          daysLeft: '2 days left',
                          playlistId: 'PLyHJZXNdCXscoyL5XEZoHHZ86_6h3GWE1', // Use a different playlist ID for questions
                        ),
                        SizedBox(width: 10),
                        ChallengeCard(
                          icon: Icons.stacked_bar_chart,
                          title: 'Data Analysis Pro',
                          subtitle: '3/7 completed',
                          daysLeft: '1 day left',
                          playlistId: 'PLDIoUOhQQPlXQMXg8zXHnqZ0JbJ1ZzZzZ', // Use a different playlist ID for questions
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Continue Learning or Explore Courses
                Text(
                  'Continue learning',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 10),
                if (continueLearningCourses.isEmpty)
                // If no courses are in progress, show "Let's Explore Courses"
                  GestureDetector(
                    onTap: () {
                      // Navigate to the Courses page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LearningPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Let's Explore Courses",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                // If courses are in progress, show the Continue Learning section
                  SizedBox(
                    height: 200, // Fixed height for the horizontal scroll view
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: continueLearningCourses.map((course) {
                          return LearningCard(
                            title: course['title'],
                            subtitle: course['subtitle'],
                            progress: course['progress'],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // Top Engineers
                Text(
                  'Top Engineers',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 10),
                const EngineerTile(
                  name: 'Alex Chen',
                  level: 'Level 20',
                  xp: '3200 XP',
                ),
                const EngineerTile(
                  name: 'Sarah Kim',
                  level: 'Level 18',
                  xp: '2900 XP',
                ),
                const EngineerTile(
                  name: 'Mike Ross',
                  level: 'Level 17',
                  xp: '2750 XP',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomProgressBar extends StatelessWidget {
  final double value;

  const CustomProgressBar({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10), // Rounded corners for the container
      child: Container(
        height: 12, // Increased height for a bolder progress bar
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), // Rounded corners
          color: const Color(0xFF1E2746), // Background color
        ),
        child: LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.transparent, // Transparent background
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2962FF)), // Progress color
          minHeight: 12, // Match the container height
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const DashboardCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.blue,
              size: 36.0, // Increased icon size
            ),
            const SizedBox(height: 10), // Increased space between icon and title
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 5), // Space between title and subtitle
            Text(
              subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class ChallengeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String daysLeft;
  final String playlistId; // Represents the set of questions

  const ChallengeCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.daysLeft,
    required this.playlistId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);

    // Calculate the progress using getCompletionProgress
    final double progress = courseProvider.getCompletionProgress(playlistId);

    return GestureDetector(
      onTap: () {
        // Navigate to the QuestionPlaylistPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionPlaylistPage(playlistId: playlistId),
          ),
        );
      },
      child: SizedBox(
        width: 300, // Fixed width for the card
        height: 130,
        child: Card(
          color: const Color(0xFF1E1E1E),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Icon and Title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, color: Colors.blue),
                    const SizedBox(width: 10), // Space between icon and title
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // Reduced space between title and subtitle

                // Subtitle
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 8), // Reduced space between subtitle and progress bar

                // Progress Bar
                Container(
                  height: 12, // Increased height for a bolder progress bar
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                    color: Colors.grey.shade900, // Background color
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10), // Rounded corners for the progress bar
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.transparent, // Transparent background to show the container's color
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue), // Progress color
                      minHeight: 12, // Match the container height
                    ),
                  ),
                ),
                const SizedBox(height: 8), // Reduced space between progress bar and daysLeft

                // Days Left
                Text(
                  daysLeft,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: const Color(0xFFFFA500)), // Orange color
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LearningCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;

  const LearningCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Card(
        color: Colors.black, // Black background
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Video Thumbnail (Rectangle Shape)
              Container(
                width: 80, // Increased width for a rectangle shape
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10), // Space between thumbnail and content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 5), // Space between title and subtitle

                    // Subtitle
                    Text(
                      subtitle.isNotEmpty ? subtitle : 'Continue where you left off', // Default text
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 10), // Space between subtitle and progress bar

                    // Progress Bar
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade900,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    const SizedBox(height: 10), // Space between progress bar and additional info
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EngineerTile extends StatelessWidget {
  final String name;
  final String level;
  final String xp;

  const EngineerTile({
    Key? key,
    required this.name,
    required this.level,
    required this.xp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  level,
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          Text(
            xp,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}