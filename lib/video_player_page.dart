import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:tech_quest/model/playlist_item.dart';

class VideoPlayerPage extends StatefulWidget {
  final YoutubePlayerController controller;
  final PlaylistItem videoInfo;

  const VideoPlayerPage({
    super.key,
    required this.controller,
    required this.videoInfo,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  bool _isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullScreen ? null : AppBar(
        title: const Text('Video Player'),
        backgroundColor: const Color(0xFF121829),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: widget.controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blue,
        ),
        onEnterFullScreen: () {
          setState(() => _isFullScreen = true);
        },
        onExitFullScreen: () {
          setState(() => _isFullScreen = false);
        },
        builder: (context, player) {
          return OrientationBuilder(
            builder: (context, orientation) {
              return Column(
                children: [
                  Expanded(
                    child: player,
                  ),
                  if (orientation == Orientation.portrait && !_isFullScreen)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.videoInfo.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.videoInfo.channelTitle,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Description:',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Add actual description if available in your model
                              const Text(
                                'Video description would go here...',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
