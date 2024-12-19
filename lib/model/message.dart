class Message {
  final String sender; // 'user' or 'LLM'
  final String message;

  Message({
    required this.sender,
    required this.message,
  });
}
