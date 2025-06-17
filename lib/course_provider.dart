import 'package:flutter/material.dart';

class CourseProvider with ChangeNotifier {
  // Map to store completion status of videos
  // Key: playlistId, Value: Map of videoId to completion status
  final Map<String, Map<String, bool>> _completionStatus = {};

  // Map to store the total number of videos for each playlist
  final Map<String, int> _totalVideos = {};

  // Get completion status of a video
  bool isVideoCompleted(String playlistId, String videoId) {
    return _completionStatus[playlistId]?[videoId] ?? false;
  }

  // Toggle completion status of a video
  void toggleVideoCompletion(String playlistId, String videoId) {
    _completionStatus[playlistId] ??= {};
    _completionStatus[playlistId]![videoId] =
    !(_completionStatus[playlistId]![videoId] ?? false);
    notifyListeners(); // Notify listeners to update the UI
  }

  // Get completion progress for a playlist
  double getCompletionProgress(String playlistId) {
    final completedVideos = _completionStatus[playlistId]?.values.where((status) => status).length ?? 0;
    final totalVideos = _totalVideos[playlistId] ?? 1; // Default to 1 to avoid division by zero
    return completedVideos / totalVideos;
  }

  // Set the total number of videos for a playlist
  void setTotalVideos(String playlistId, int totalVideos) {
    _totalVideos[playlistId] = totalVideos;
    notifyListeners();
  }

  // Map to store user answers for questions
  final Map<String, String> _userAnswers = {};

  // Save the user's answer
  void setAnswer(String questionId, String answer) {
    _userAnswers[questionId] = answer;
    notifyListeners();
  }

  // Get the user's answer
  String getAnswer(String questionId) {
    return _userAnswers[questionId] ?? '';
  }
}