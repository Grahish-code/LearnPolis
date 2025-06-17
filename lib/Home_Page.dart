import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage:
                      AssetImage('assets/FRAME.png'), // Replace with actual image URL
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alex Mitchell',
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

                // Active Challenges
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Active Challenges',
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
                          title: 'Algorithm Master',
                          subtitle: '2/5 completed',
                          daysLeft: '2 days left',
                          progress: 0.4, // 2 out of 5 completed
                        ),
                        SizedBox(width: 10),
                        ChallengeCard(
                          icon: Icons.stacked_bar_chart,
                          title: 'Data Analysis Pro',
                          subtitle: '3/7 completed',
                          daysLeft: '1 day left',
                          progress: 0.43, // 3 out of 7 completed
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Continue Learning
                Text(
                  'Continue learning',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200, // Fixed height for the horizontal scroll view
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: const [
                        LearningCard(
                          title: 'Thermodynamics 101',
                          subtitle: 'Continue where you left off',
                          progress: 0.5,
                        ),
                        SizedBox(width: 10),
                        LearningCard(
                          title: 'Fluid Mechanics',
                          subtitle: 'Continue where you left off',
                          progress: 0,
                        ),
                      ],
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

  const DashboardCard(
      {Key? key, required this.icon, required this.title, required this.subtitle})
      : super(key: key);

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
  final double progress;

  const ChallengeCard(
      {Key? key,
        required this.icon,
        required this.title,
        required this.subtitle,
        required this.daysLeft,
        required this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}



class LearningCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;

  const LearningCard(
      {Key? key, required this.title, required this.subtitle, required this.progress})
      : super(key: key);

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
                    const SizedBox(height: 10), // Space between progress bar and button

                    // Continue Button
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 40), // Full-width button
                      ),
                      child: const Text('Continue'),
                    ),
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

  const EngineerTile({Key? key, required this.name, required this.level, required this.xp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: AssetImage('assets/FRAME.png'), // Replace with actual image URL
      ),
      title: Text(
        name,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
      ),
      subtitle: Text(
        '$level  •  $xp',
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Colors.grey),
      ),
      trailing: const Icon(Icons.military_tech, color: Colors.amber),
    );
  }
}