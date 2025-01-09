import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:game/client/image_client.dart';
import 'package:game/page/home_page.dart';
import 'package:game/theme/theme.dart';
import '../client/api_client.dart';
import 'postgame_page.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class GamePage extends StatefulWidget {
  final String movieName;
  final String chatName;
  final String? movieId;
  final Map<String, int>? characterValues;
  final String? characterName;
  final String? threadId;
  final bool isNewGame;
  final int? sp;
  final int? hp;
  final int? stepCount;
  final int? progress;


  const GamePage({
    Key? key,
    required this.movieName,
    required this.chatName,
    this.movieId,
    this.characterValues,
    this.characterName,
    this.threadId,
    required this.isNewGame,
    this.sp,
    this.hp,
    this.stepCount,
    this.progress,
  }) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final apiClient = ApiClient();
  final imageClient = ImageClient();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  List<String> _options = [];

  Image? backgroundImage;
  String? threadId;
  bool isTyping = false;
  bool isLoading = false;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _backgroundFadeAnimation;
  int healthPoint = 100;
  int staminaPoint = 100;
  int progressValue = 50;
  int steps = 0;
  double finalScore = 0.0;
  bool isVictory = false;
  bool isCut = false;

  // Callback function to update message text
  void updateMessageText(int index, String text) {
    if (mounted) {
      setState(() {
        if (index < _messages.length) {
          _messages[index]['text'] = text;
        }
      });
      // Scroll to bottom when message updates
      _scrollToBottom();
    }
  }

  // Callback function to update message status  
  void updateMessageStatus(int index, String status) {
    if (mounted) {
      setState(() {
        if (index < _messages.length) {
          _messages[index]['status'] = status;
        }
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _backgroundFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    if(widget.isNewGame){
      startChat();
    } else{
      loadGame();
    }
    getBackgroundImage(widget.movieName, '');
  }

  Future<void> loadGame() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await apiClient.getChatHistory(widget.threadId!);
      final messages = response['messages'] as List;

      // Set the threadId from the first message
      if (messages.isNotEmpty) {
        threadId = messages[0]['thread_id'];
      }

      // Create a temporary list to hold all messages
      final List<Map<String, dynamic>> tempMessages = [];

      // Process messages in reverse order to maintain chronological order
      for (var message in messages.reversed) {
        final isAssistant = message['role'] == 'assistant';
        tempMessages.add({
          'isMe': !isAssistant,
          'text': message['content'],
          'time': TimeOfDay.now().format(context),
          'status': 'read',
        });
      }

      // Update state once with all messages
      setState(() {
        _messages.addAll(tempMessages);
        healthPoint = widget.hp!;
        staminaPoint = widget.sp!;
        steps = widget.stepCount!;
        threadId = widget.threadId!;
        progressValue = widget.progress!;
        isLoading = false;
      });

      // Wait for the next frame when messages are rendered
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Add a small delay to ensure the ListView has been fully rendered
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && _scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      });

    } catch (e) {
      print('Error loading game history: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading game history: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
          image: backgroundImage != null
              ? DecorationImage(
                  image: backgroundImage!.image,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(_backgroundFadeAnimation.value),
                    BlendMode.darken,
                  ),
                )
              : null,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Game Header
              _buildGameHeader(),
              
              // Progress and Stats Bar
              _buildProgressBar(),
              
              // Messages List
              Expanded(
                child: _buildMessagesList(),
              ),

              // Loading Bar
              if (isLoading) _buildLoadingBar(),

              // Input Bar
              _buildInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameHeader() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingSmall),
      decoration: BoxDecoration(
        color: Colors.black54,
      ),
      child: Row(
        children: [
          const SizedBox(width: AppTheme.paddingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.movieName,
                  style: TextStyle(
                    color: AppTheme.accent,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _buildMenuButton(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.paddingSmall),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatChip(Icons.favorite, "Health", healthPoint.toString()),
              _buildStatChip(Icons.flash_on, "Energy", staminaPoint.toString()),
              _buildStatChip(Icons.directions_run, "Steps", steps.toString()),
            ],
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progressValue / 100,
                  backgroundColor: Colors.white10,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
                  minHeight: 30,
                ),
              ),
              Text(
                '$progressValue%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingSmall,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.accent, size: 16),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingSmall,
        vertical: AppTheme.paddingSmall,
      ),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        return _buildMessageBubble(msg);
      },
    );
  }


  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isMe = message['isMe'] as bool;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.paddingSmall),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) _buildCharacterAvatar(),
          const SizedBox(width: AppTheme.paddingSmall),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(AppTheme.paddingSmall),
              decoration: BoxDecoration(
                color: isMe ? AppTheme.accent.withOpacity(0.9) : Colors.black54,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isMe ? AppTheme.accent : Colors.white24,
                  width: 1,
                ),
              ),
              child: MarkdownBody(
                data: message['text'] ?? '',
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(color: Colors.white),
                  code: const TextStyle(
                    color: Colors.amber,
                    backgroundColor: Colors.black26,
                  ),
                  strong: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  em: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                  listBullet: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 4),
            Icon(
              message['status'] == 'read' ? Icons.done_all : Icons.done,
              color: Colors.white60,
              size: 16,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCharacterAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppTheme.accentGradient,
      ),
      child: const Icon(Icons.person, color: Colors.white),
    );
  }

  void createButtonsFromResponse(String message) {
    if (message.isEmpty) {
      setState(() => _options = []);
      return;
    }

    // Split message into lines
    final lines = message.split('\n');
    final List<String> options = [];

    // Look for numbered options (e.g., "1. Do something")
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (RegExp(r'^\d+\.\s').hasMatch(line)) {
        // Extract the full option text without the number prefix
        final optionText = line.replaceFirst(RegExp(r'^\d+\.\s'), '').trim();
        if (optionText.isNotEmpty) {
          options.add(optionText);
        }
      }
    }
    print(options);
    setState(() => _options = options);
  }

  Widget _buildInputBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _options.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: SizedBox(
                  width: 120,
                  child: AbsorbPointer(
                    absorbing: (isLoading || isVictory || isCut),  // Disable interaction when isLoading is true
                    child: ElevatedButton(
                      onPressed: () => _sendMessage(customText: entry.value),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: MarkdownBody(
                        data: '${
                          entry.value.substring(0,
                              entry.value.length > 7 ? 7 : entry.value.length)
                        }...',
                        styleSheet: MarkdownStyleSheet(
                          p: const TextStyle(color: Colors.white),
                          code: const TextStyle(
                            color: Colors.amber,
                            backgroundColor: Colors.black26,
                          ),
                          strong: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          em: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                          listBullet: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 10),
        // Regular input bar
        AbsorbPointer( // Disable the TextField and IconButton when isLoading is true
          absorbing: (isLoading || isVictory || isCut),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.paddingSmall),
            decoration: BoxDecoration(
              color: Colors.black54,
              border: Border(top: BorderSide(color: AppTheme.accent.withOpacity(0.3))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingSmall),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'What would you like to do?',
                        hintStyle: TextStyle(color: Colors.white60),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildLoadingBar() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.paddingSmall),
      child: LinearProgressIndicator(
        backgroundColor: Colors.white10,
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
      ),
    );
  }

  Widget _buildMenuButton() {
    return IconButton(
      icon: const Icon(Icons.pause, color: Colors.white),
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.black87,
              title: Text(
                'Game Paused',
                style: TextStyle(color: AppTheme.accent),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.exit_to_app, color: AppTheme.accent),
                    title: const Text('Exit Game', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _sendMessage({String? customText}) {
    final message = customText ?? _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({
        'isMe': true,
        'text': message,
        'time': TimeOfDay.now().format(context),
        'status': 'sent',
      });
      _controller.clear();
    });

    _scrollToBottom();

    if (threadId != null) {
      print('Continuing chat with thread id: $threadId');
      continueChat(message, threadId!);
    }
  }

  Future<void> getBackgroundImage(String movieName, String? message) async {
    try {
      final images = await imageClient.getImage(movieName, message);
      if (images.isNotEmpty) {
        setState(() {
          backgroundImage = images[0]; // Set the first image as the background
        });
        _fadeController.forward(); // Start the fade-in animation
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

  Future<void> startChat() async {
    String message = 'Hello';
    String accumulatedMessage = ''; // Accumulates incoming text from the server
    String buffer = '';            // Holds partial data until a complete JSON object is found

    // Prepare your request body
    final Map<String, dynamic> requestBody = {
      'characterName': widget.characterName,
      'movieName': widget.movieId,
      'chatName': widget.chatName,
      'message': message,
      if (widget.characterValues != null) ...?widget.characterValues,
    };

    try {
      setState(() {
        isLoading = true;
      });

      // 1. Request a real streaming response from the API
      final Stream<String> chatStream = await apiClient.startChat(requestBody);

      setState(() {
        isLoading = false;
      });

      // 2. Create a placeholder in the UI for the incoming message
      setState(() {
        _messages.add({
          'isMe': false,
          'text': '',
          'time': TimeOfDay.now().format(context),
          'status': 'streaming',
        });
      });

      final int lastIndex = _messages.length - 1;

      // 3. Listen for chunks from the stream
      await for (final newChunk in chatStream) {
        try {
          // Append chunk to our buffer
          print(newChunk);
          buffer += newChunk;

          // While we can find a closing brace, parse out one complete JSON object at a time
          while (true) {
            final endIndex = buffer.indexOf('}');
            if (endIndex == -1) {
              // No complete JSON object yet
              break;
            }

            // Extract the complete JSON object
            final completeJson = buffer.substring(0, endIndex + 1);
            // Remove it from the buffer
            buffer = buffer.substring(endIndex + 1);

            // Attempt to parse
            final Map<String, dynamic> parsedMessage = jsonDecode(completeJson);
            print(parsedMessage);
            // Check for thread ID (if the server provides it)
            if (parsedMessage['thread_id'] != null) {
              setState(() {
                threadId = parsedMessage['thread_id'];
              });
            }

            if(parsedMessage.keys.contains('isMeta')){
              if (parsedMessage['isMeta'] == true) {
                setState(() {
                  progressValue = parsedMessage['progress_level'];
                  healthPoint = parsedMessage['hp'];
                  staminaPoint = parsedMessage['sp'];
                });
              }
            }

            // Append text if this JSON object contains a chunk of the message
            if (parsedMessage['contains_msg'] == true) {
              accumulatedMessage += parsedMessage['message'] ?? '';
              updateMessageText(lastIndex, accumulatedMessage);

              // If the server indicates the message is complete, mark as read
              if (parsedMessage['is_complete'] == true) {
                updateMessageStatus(lastIndex, 'read');
              }
            }

          }
        } catch (e) {
          print('Error processing chunk: $e');
        }
      }
      print('selam12');
      createButtonsFromResponse(accumulatedMessage);
    } catch (e) {
      print('Error starting chat: $e');

      setState(() {
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting chat: $e')),
        );
      }
    }
  }

  String? getLastUserMessage() {
    for (int i = _messages.length - 1; i >= 0; i--) {
      final message = _messages[i];
      if (message['isMe'] == true && message['text'] != null) {
        return message['text'] as String;
      }
    }
    return null;
  }

  Future<void> continueChat(String message, String threadId) async {
    String accumulatedMessage = ''; // We'll accumulate the entire textual response here
    String buffer = '';            // Holds partial data until we find a complete JSON object

    try {
      setState(() {
        isLoading = true;
      });

      // 1. Fetch the Stream<String> from your API client
      final Stream<String> chatStream = await apiClient.continueChat(message, threadId);

      setState(() {
        isLoading = false;
      });

      // 2. Add a placeholder message in the UI for the streaming response
      setState(() {
        _messages.add({
          'isMe': false,
          'text': '',            // Will be updated incrementally
          'time': TimeOfDay.now().format(context),
          'status': 'streaming', // Indicate that we're still receiving data
        });
      });

      final int lastIndex = _messages.length - 1;
      _scrollToBottom();

      // 3. Listen to the stream using `await for` so we can handle partial chunks
      await for (final newChunk in chatStream) {
        if (!mounted) return;  // In case the widget was disposed

        try {
          // a) Accumulate new chunk into buffer
          print(newChunk);
          buffer += newChunk;

          // b) Keep parsing as long as we find a '}' in the buffer
          //    (indicating a potentially complete JSON object)
          while (true) {
            // Find the first occurrence of '}'
            final jsonEnd = buffer.indexOf('}');
            if (jsonEnd == -1) {
              // No closing brace yet -> not enough data to form a valid JSON object
              break;
            }

            // Extract the substring from start to the closing brace
            final completeJson = buffer.substring(0, jsonEnd + 1);
            // Remove that portion from the buffer
            buffer = buffer.substring(jsonEnd + 1);

            // Attempt to parse the complete JSON object
            final Map<String, dynamic> parsedMessage = jsonDecode(completeJson);

            print(parsedMessage);

            if(parsedMessage.keys.contains('isMeta')){
              if (parsedMessage['isMeta'] == true) {
                setState(() {
                  progressValue = parsedMessage['progress_level'];
                  healthPoint = parsedMessage['hp'];
                  staminaPoint = parsedMessage['sp'];
                  steps = parsedMessage['step_count'];
                });
              }
            }

            // TODO: Tutorial diye bir yer ekle.

            if(parsedMessage.keys.contains('gameFinished')){
              if (parsedMessage['gameFinished'] == true) {
                setState(() {
                  finalScore = parsedMessage['finalScore'];
                  isVictory = parsedMessage['isWin'];
                  isCut = parsedMessage['isCut'];
                });
                sleep(Duration(seconds: 5));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameFinishedPage(
                      score: finalScore,
                      isVictory: isVictory,
                      isCut: isCut,
                      movieName: widget.movieName,
                    ),
                  ),
                );
              }
            }

            // If `done` is false, we're still receiving partial text
            if (parsedMessage['done'] == false) {
              // Append this partial text to our accumulated message
              accumulatedMessage += parsedMessage['message'] ?? '';

              // Update the message bubble
              updateMessageText(lastIndex, accumulatedMessage);

            } else if (parsedMessage['done'] == true) {
              accumulatedMessage += parsedMessage['message'] ?? '';
              updateMessageText(lastIndex, accumulatedMessage);
              updateMessageStatus(lastIndex, 'read');
              print('buradayım');
              createButtonsFromResponse(accumulatedMessage);
            }

            _scrollToBottom();
          }
        } catch (e) {
          // If there's an error parsing this chunk, log it
          print('Error processing chunk: $e');
        }
      }

      if (steps % 5 == 0) {
        String? lastMessage = getLastUserMessage();
        if (lastMessage != null) {
          getBackgroundImage(widget.movieName, lastMessage);
        }
      }

    } catch (e) {
      print('Error continuing chat: $e');

      setState(() {
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error continuing chat: $e')),
        );
      }
    }
  }
}