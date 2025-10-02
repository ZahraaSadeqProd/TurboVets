import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Data model for messages to map who sent what message (user vs agent)
class Message {
  final String text;
  final bool fromUser;
  final DateTime timestamp;
  Message({required this.text, required this.fromUser, required this.timestamp});
  Map<String, dynamic> toMap() => {
        'text': text,
        'fromUser': fromUser,
        'timestamp': timestamp.toIso8601String(),
      };
  factory Message.fromMap(Map<String, dynamic> map) => Message(
        text: map['text'],
        fromUser: map['fromUser'],
        timestamp: DateTime.parse(map['timestamp']),
      );
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = []; // keep track of all chat messages on screen
  final TextEditingController _controller = TextEditingController(); // manage bottom text inout field
  final ScrollController _scrollController = ScrollController(); // scroll list programmatically
  late SharedPreferences _prefs; // local storage

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  // once app opened, retrieve stored JSON messages from local storage 
  Future<void> _loadMessages() async {
    _prefs = await SharedPreferences.getInstance();
    final stored = _prefs.getStringList('messages') ?? [];
    final loaded = stored.map((msg) => Message.fromMap(jsonDecode(msg))).toList();
    setState(() {
      _messages.clear();
      _messages.addAll(loaded);
    });
    _scrollToBottom();
  }

  // when there is new message/update store it
  Future<void> _saveMessages() async {
    final encoded = _messages.map((m) => jsonEncode(m.toMap())).toList();
    await _prefs.setStringList('messages', encoded);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    final userMessage = Message(text: text.trim(), fromUser: true, timestamp: DateTime.now());
    setState(() => _messages.add(userMessage));
    _controller.clear();
    _scrollToBottom();
    _saveMessages();

    Future.delayed(const Duration(seconds: 1), () {
      final reply = Message(text: 'Agent reply to: "$text"', fromUser: false, timestamp: DateTime.now());
      setState(() => _messages.add(reply));
      _scrollToBottom();
      _saveMessages();
    });
  }

  Widget _buildMessageBubble(Message msg) {
    final alignment = msg.fromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bubbleColor = msg.fromUser
        ? Theme.of(context).primaryColor
        : (isDark ? const Color(0xFF2C2C2C) : Colors.grey[300]!);

    final textColor = msg.fromUser
        ? Colors.white
        : (isDark ? Colors.white : Colors.black);

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(12).copyWith(
              bottomLeft: msg.fromUser ? const Radius.circular(12) : Radius.zero,
              bottomRight: msg.fromUser ? Radius.zero : const Radius.circular(12),
            ),
          ),
          child: Text(msg.text, style: TextStyle(color: textColor, fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.only(right: msg.fromUser ? 12 : 0, left: msg.fromUser ? 0 : 12),
          child: Text(_formatTimestamp(msg.timestamp), style: TextStyle(fontSize: 10, color: Colors.grey[400])),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final h = timestamp.hour.toString().padLeft(2, '0');
    final m = timestamp.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _messages.length,
            itemBuilder: (context, index) => _buildMessageBubble(_messages[index]),
          ),
        ),
        SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).inputDecorationTheme.fillColor,
              border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                    decoration: const InputDecoration(hintText: "Type a message..."),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
