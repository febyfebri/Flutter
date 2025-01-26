import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:slicing_1/components/chat_bubble.dart';
import 'package:slicing_1/model/Chat.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
    final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        chatMessages.add(ChatMessage(
          text: _controller.text,
          color: Color(0xFFE8E8EE),
          tail: true,
          isSender: true,
          textStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ));
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nama'),),
      body: SafeArea(
        child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                ChatMessage message = chatMessages[index];
                return BubbleSpecialThree(
                  text: message.text,
                  color: message.color,
                  tail: message.tail,
                  textStyle: message.textStyle,
                  isSender: message.isSender,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                      hintText: "Type a message",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8,vertical: 8)
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400
                    ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}