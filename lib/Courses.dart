import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_quest/playlist_page.dart'; // Replace with your app name
import 'course_provider.dart'; // Import the CourseProvider

class LearningPage extends StatelessWidget {
  const LearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        backgroundColor: const Color(0xFF121829),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFF121829),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCourseCard(
                      title: 'Coding In Java',
                      description: 'Learn the fundamentals of Coding and Java',
                      level: 'Beginner',
                      category: 'Computer Science',
                      duration: '8 weeks',
                      students: '1250+ students',
                      playlistId: 'PLfqMhTWNBTe3LtFWcvwpqTkUSlB32kJop', // Replace with your playlist ID
                      courseProvider: courseProvider,
                      onContinuePressed: () {
                        // Navigate to the PlaylistPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PlaylistPage(
                              playlistId: 'PLfqMhTWNBTe3LtFWcvwpqTkUSlB32kJop', // Replace with your playlist ID
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildCourseCard(
                      title: 'Engineering Mathematics',
                      description: 'Explore the principles of Maths in Engineering',
                      level: 'Intermediate',
                      category: 'Civil',
                      duration: '10 weeks',
                      students: '980+ students',
                      playlistId: 'PLvTTv60o7qj_tdY9zH7YceES7jfXiZkAz', // Replace with your playlist ID
                      courseProvider: courseProvider,
                      onContinuePressed: () {
                        // Navigate to the PlaylistPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PlaylistPage(
                              playlistId: 'PLvTTv60o7qj_tdY9zH7YceES7jfXiZkAz', // Replace with your playlist ID
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard({
    required String title,
    required String description,
    required String level,
    required String category,
    required String duration,
    required String students,
    required String playlistId,
    required CourseProvider courseProvider,
    required VoidCallback onContinuePressed,
  }) {
    // Calculate completion progress
    double completionProgress = courseProvider.getCompletionProgress(playlistId);

    return Card(
      color: const Color(0xFF1E1E1E),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoChip(label: level, color: Colors.blue),
                const SizedBox(width: 8),
                _buildInfoChip(label: category, color: Colors.green),
              ],
            ),
            const SizedBox(height: 16),
            // Progress Bar
            LinearProgressIndicator(
              value: completionProgress,
              backgroundColor: Colors.grey[800],
              color: Colors.blue,
            ),
            const SizedBox(height: 8),
            Text(
              '${(completionProgress * 100).toStringAsFixed(0)}% completed',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.schedule, color: Colors.grey, size: 16),
                const SizedBox(width: 4),
                Text(
                  duration,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.people, color: Colors.grey, size: 16),
                const SizedBox(width: 4),
                Text(
                  students,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onContinuePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 40),
              ),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}