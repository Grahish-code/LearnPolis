import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:tech_quest/services/youtube_api.dart'; // Replace with your app name
import 'package:tech_quest/model/playlist_item.dart'; // Replace with your app name
import 'package:tech_quest/video_player_page.dart'; // Replace with your app name
import 'course_provider.dart'; // Import the CourseProvider

class PlaylistPage extends StatefulWidget {
  final String playlistId;

  const PlaylistPage({super.key, required this.playlistId});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}
class _PlaylistPageState extends State<PlaylistPage> {
  late YoutubePlayerController _controller;
  List<PlaylistItem> _playlistItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaylist();
  }

  Future<void> _loadPlaylist() async {
    try {
      final items = await YouTubeApi.fetchPlaylistItems(widget.playlistId);
      final courseProvider = Provider.of<CourseProvider>(context, listen: false);
      courseProvider.setTotalVideos(widget.playlistId, items.length); // Set total videos
      setState(() {
        _playlistItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load playlist: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlist'),
        backgroundColor: const Color(0xFF121829),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _playlistItems.length,
        itemBuilder: (context, index) {
          final video = _playlistItems[index];
          return Card(
            color: const Color(0xFF1E1E1E),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () {
                // Play the selected video
                _controller = YoutubePlayerController(
                  initialVideoId: video.videoId,
                  flags: const YoutubePlayerFlags(
                    autoPlay: true,
                    mute: false,
                    enableCaption: true,
                    disableDragSeek: true,
                    useHybridComposition: true,
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerPage(
                      controller: _controller,
                      videoInfo: video, // Pass the current PlaylistItem here
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        video.thumbnailUrl,
                        width: 120,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Video Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Video Title
                          Text(
                            video.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          // Channel Name
                          Text(
                            video.channelTitle,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Checkbox for completion
                    Checkbox(
                      value: courseProvider.isVideoCompleted(widget.playlistId, video.videoId),
                      onChanged: (value) {
                        courseProvider.toggleVideoCompletion(widget.playlistId, video.videoId);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}