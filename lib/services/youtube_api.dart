import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tech_quest/model/playlist_item.dart';

class YouTubeApi {
  static const String apiKey = 'AIzaSyDUYytnnWgh2JYUkmsaI_-8oql7UY1nTqw'; // Your API key
  static const String baseUrl = 'https://www.googleapis.com/youtube/v3';

  static Future<List<PlaylistItem>> fetchPlaylistItems(String playlistId) async {
    final url = '$baseUrl/playlistItems?part=snippet&maxResults=50&playlistId=$playlistId&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'] as List;
      return items.map((item) {
        final snippet = item['snippet'];
        return PlaylistItem(
          videoId: snippet['resourceId']['videoId'],
          title: snippet['title'],
          thumbnailUrl: snippet['thumbnails']['high']['url'],
          channelTitle: snippet['channelTitle'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load playlist');
    }
  }
}