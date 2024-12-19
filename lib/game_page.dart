import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:game/client/image_client.dart';

import 'client/api_client.dart';

class GamePage extends StatefulWidget {
  final String movieName;
  final String chatName;
  final Map<String, int> characterValues;

  const GamePage({
    Key? key,
    required this.movieName,
    required this.chatName,
    required this.characterValues,
  }) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final TextEditingController _controller = TextEditingController();
  final apiClient = ApiClient();
  final imageClient = ImageClient();
  Image? backgroundImage;
  String? threadId = null;
  double progressValue = 50.0; // Initial progress value
  final accentColor = const Color(0xFFE2543E); // Adjust as needed

  @override
  void initState() {
    super.initState();
    startChat();
    getBackgroundImage();

  }

  Future<void> getBackgroundImage() async {
    try {
      final images = await imageClient.getImage();
      if (images.isNotEmpty) {
        setState(() {
          backgroundImage = images[0]; // Set the first image as the background
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No images returned by the server')),
        );
      }
    } catch (e) {
      print('Error fetching background image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load background image')),
      );
    }
  }



  final List<Map<String, dynamic>> _messages = [];

  Future<void> startChat() async {
    String message = 'Merhaba';
    String accumulatedMessage = ''; // To accumulate messages
    String buffer = ''; // Buffer to store incomplete JSON chunks

    Map<String, dynamic> requestBody = {
      'movieName': widget.movieName,
      'chatName': widget.chatName,
      'message': message,
    };

    requestBody.addAll(widget.characterValues);

    try {
      // Fetch the text stream from the API
      Stream<String> chatStream = await apiClient.startChat(requestBody);

      setState(() {
        _messages.add({
          'isMe': false,
          'text': '',
          'time': TimeOfDay.now().format(context),
          'status': 'streaming',
        });
      });

      int lastIndex = _messages.length - 1; // Track the last message index

      chatStream.listen((newChunk) {
        try {
          // Add new chunk to the buffer
          buffer += newChunk;

          // Process complete JSON objects in the buffer
          while (buffer.contains('}') || buffer.contains(']')) {
            int jsonEnd = buffer.indexOf('}') + 1;

            // Extract the complete JSON object
            String completeJson = buffer.substring(0, jsonEnd);

            // Attempt to parse JSON
            final Map<String, dynamic> parsedMessage = jsonDecode(completeJson);

            // Remove processed JSON from buffer
            buffer = buffer.substring(jsonEnd);

            // Handle thread_id
            if (parsedMessage['thread_id'] != null) {
              setState(() {
                threadId = parsedMessage['thread_id'];
              });
            }

            // If contains_msg is true, accumulate the message
            if (parsedMessage['contains_msg'] == true) {
              accumulatedMessage += parsedMessage['message'];

              setState(() {
                _messages[lastIndex]['text'] = accumulatedMessage;
              });
            }

            // Simulate progress value update
            setState(() {
              progressValue = (progressValue + 10).clamp(0, 100);
            });
          }
        } catch (e) {
          print('Error processing chunk: $e');
        }
      });
    } catch (e) {
      print('Error starting chat: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error starting chat: $e')),
      );
    }
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) {
      return; // Prevent sending empty messages
    }

    String message = _controller.text.trim();

    setState(() {
      _messages.add({
        'isMe': true,
        'text': message,
        'time': TimeOfDay.now().format(context), // Get the current time
        'status': 'sent',
      });
      _controller.clear(); // Clear the input field
    });

    continueChat(message, threadId!);
  }

  Future<void> continueChat(String message, String threadId) async {
    // Implementation for continuing the chat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE3EBE7), // Your desired background color
            image: backgroundImage != null
                ? DecorationImage(
              image: backgroundImage!.image, // Use the Image's image property
              fit: BoxFit.cover, // Adjust as needed
            )
                : null, // Keep the color until the image is available
          ),
          child: Column(
            children: [
              // Top bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.white.withOpacity(0.8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.chatName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            widget.movieName,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Progress bar
              ProgressBar(value: progressValue),

              // Messages List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  reverse: false,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isMe = msg['isMe'] as bool;
                    final hasText = msg.containsKey('text');
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          if (hasText)
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.7,
                              ),
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: isMe ? accentColor : Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Text(
                                msg['text'],
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                msg['time'],
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(width: 4),
                              if (isMe && msg['status'] == 'read') ...[
                                Icon(Icons.check, size: 14, color: Colors.grey),
                                Icon(Icons.check, size: 14, color: Colors.grey),
                              ],
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom input bar
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                decoration: const InputDecoration(
                                  hintText: 'Write a message',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.emoji_emotions_outlined),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
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



class ProgressBar extends StatelessWidget {
  final double value;

  const ProgressBar({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color progressColor;

    if (value < 33) {
      progressColor = Colors.red;
    } else if (value < 66) {
      progressColor = Colors.yellow;
    } else {
      progressColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 16.0, // Adjust this value to make the bar thicker or thinner
              child: LinearProgressIndicator(
                value: value / 100,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
          ),
          const SizedBox(width: 8.0), // Spacing between bar and percentage text
          Text(
            "${value.toStringAsFixed(0)}%", // Format percentage text
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

