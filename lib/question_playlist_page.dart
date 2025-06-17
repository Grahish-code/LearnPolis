import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'course_provider.dart'; // Import the CourseProvider
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuestionPlaylistPage extends StatefulWidget {
  final String playlistId; // Represents the set of questions

  const QuestionPlaylistPage({super.key, required this.playlistId});

  @override
  State<QuestionPlaylistPage> createState() => _QuestionPlaylistPageState();
}

class _QuestionPlaylistPageState extends State<QuestionPlaylistPage> {
  // Static list of web development-related theoretical questions
  final List<Map<String, String>> _questions = [
    {
      'id': '1',
      'question': 'Explain the difference between HTTP and HTTPS.',
    },
    {
      'id': '2',
      'question': 'What is the purpose of CSS preprocessors like SASS or LESS?',
    },
    {
      'id': '3',
      'question': 'Describe the box model in CSS and its components.',
    },
    {
      'id': '4',
      'question': 'What are the key features of React.js?',
    },
    {
      'id': '5',
      'question': 'Explain the concept of closures in JavaScript.',
    },
    // Add more questions here
  ];

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Development Questions'),
        backgroundColor: const Color(0xFF121829),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          final question = _questions[index];
          return QuestionCard(
            questionId: question['id']!,
            questionText: question['question']!,
            courseProvider: courseProvider,
          );
        },
      ),
    );
  }
}



class QuestionCard extends StatefulWidget {
  final String questionText;
  final String questionId;
  final CourseProvider courseProvider;

  const QuestionCard({
    Key? key,
    required this.questionText,
    required this.questionId,
    required this.courseProvider,
  }) : super(key: key);

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  final TextEditingController _answerController = TextEditingController();
  bool _isSubmitted = false;
  String _chatbotFeedback = "";

  void _submitAnswer() async {
    if (_answerController.text.isNotEmpty) {
      setState(() {
        _isSubmitted = true;
      });

      widget.courseProvider.setAnswer(widget.questionId, _answerController.text);

      // Get chatbot feedback
      String feedback = await getChatbotFeedback(widget.questionText, _answerController.text);
      setState(() {
        _chatbotFeedback = feedback;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an answer before submitting.')),
      );
    }
  }

  Future<String> getChatbotFeedback(String question, String userAnswer) async {
    const String apiKey = 'dh1VxZXDayx8iqLdwMQzyFRrqTG3QxHYYT5Yc3WR'; // Replace with actual key
    const String apiUrl = 'https://api.cohere.ai/v1/generate';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'command',
        'prompt': "Evaluate the following answer strictly:\n\n"
            "**Question:** $question\n"
            "**User's Answer:** $userAnswer\n\n"
            "1. Check if the answer is **correct** (yes/no).\n"
            "2. If incorrect, provide a **brief correct answer**.\n"
            "3. Check **plagiarism** and indicate if the answer is copied (yes/no).\n"
            "4. Keep the response concise and in bullet points.",
        'max_tokens': 150,
        'temperature': 0.5,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['generations'][0]['text'].trim(); // Extract chatbot's feedback
    } else {
      return 'Error evaluating answer: ${response.statusCode}';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.questionText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your Answer',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isSubmitted ? null : _submitAnswer,
              child: const Text('Submit Answer'),
            ),
            if (_isSubmitted) ...[
              const SizedBox(height: 10),
              Text(
                'Chatbot Feedback:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(_chatbotFeedback, style: const TextStyle(color: Colors.blue)),
            ],
          ],
        ),
      ),
    );
  }
}

