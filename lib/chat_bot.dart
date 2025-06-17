import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Message({required this.text, required this.isUser, required this.timestamp});
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = [];
  bool _isLoading = false;
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // Constants for Cohere API
  static const String apiKey = 'dh1VxZXDayx8iqLdwMQzyFRrqTG3QxHYYT5Yc3WR';
  static const String apiUrl = 'https://api.cohere.ai/v1/generate';
  static const String model = 'command';
  static const int maxTokens = 100;
  static const double temperature = 0.7;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final userInput = _controller.text.trim();
    if (userInput.isEmpty) return;

    setState(() {
      messages.add(Message(
        text: userInput,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _controller.clear();
      _isLoading = true;
    });

    _animationController.forward();
    _scrollToBottom();

    try {
      final chatbotResponse = await getChatbotResponse(userInput);
      setState(() {
        messages.add(Message(
          text: chatbotResponse,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      _animationController.reset();
      _animationController.forward();
    } catch (e) {
      setState(() {
        messages.add(Message(
          text: 'I apologize, but I encountered an error processing your request. Please try again.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<String> getChatbotResponse(String userInput) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': model,
        'prompt': userInput,
        'max_tokens': maxTokens,
        'temperature': temperature,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('generations') && data['generations'].isNotEmpty) {
        return data['generations'][0]['text'].toString().trim();
      } else {
        throw Exception('Invalid response structure');
      }
    } else {
      throw Exception('Failed to load response: ${response.statusCode}');
    }
  }

  Widget _buildMessage(Message message, int index) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: index == messages.length - 1 ? _scaleAnimation.value : 1.0,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment:
              message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!message.isUser) ...[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF667eea).withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                ],
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: message.isUser
                          ? LinearGradient(
                        colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : LinearGradient(
                        colors: [Color(0xFFf8f9fa), Color(0xFFe9ecef)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
                          style: TextStyle(
                            color: message.isUser ? Colors.white : Color(0xFF2c3e50),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: message.isUser
                                ? Colors.white.withOpacity(0.8)
                                : Color(0xFF6c757d),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (message.isUser) ...[
                  SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF4facfe).withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.psychology,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFFf8f9fa),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                SizedBox(width: 4),
                _buildDot(1),
                SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + 0.3 *
              (0.5 + 0.5 *
                  math.sin((_animationController.value * 2 * math.pi) +
                      (index * math.pi / 3))),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Color(0xFF667eea),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f7fa),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.school,
                color: Colors.white,
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Academic Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Your AI Study Companion',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                messages.clear();
              });
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.only(top: 16, bottom: 16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return _buildMessage(messages[index], index);
                },
              ),
            ),
            if (_isLoading) _buildTypingIndicator(),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(60),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF667eea).withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.psychology,
              color: Colors.white,
              size: 60,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Welcome to Academic Assistant',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2c3e50),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ask me anything about your studies!\nI\'m here to help you learn and understand.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6c757d),
              height: 1.5,
            ),
          ),
          SizedBox(height: 32),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildSuggestionChip('Explain quantum physics'),
              _buildSuggestionChip('Help with calculus'),
              _buildSuggestionChip('Literature analysis'),
              _buildSuggestionChip('Historical events'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return GestureDetector(
      onTap: () {
        _controller.text = text;
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFF667eea).withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xFF667eea),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFf8f9fa),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Color(0xFFe9ecef)),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Ask me an academic question...',
                    hintStyle: TextStyle(color: Color(0xFF6c757d)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    prefixIcon: Icon(
                      Icons.lightbulb_outline,
                      color: Color(0xFF667eea),
                    ),
                  ),
                  style: TextStyle(fontSize: 16),
                  maxLines: null,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF4facfe).withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(25),
                  onTap: _isLoading ? null : _sendMessage,
                  child: Container(
                    width: 50,
                    height: 50,
                    child: Icon(
                      _isLoading ? Icons.hourglass_empty : Icons.send_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Add this import at the top of the file
