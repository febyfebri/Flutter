import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:slicing_1/components/chat_bubble.dart';
import 'package:slicing_1/model/Chat.dart';
import 'package:slicing_1/network/Firestore.dart';

class ChatScreen extends StatefulWidget {
  final String contactEmail;
  final String chatRoomID;
  final String currentUserUID;

  ChatScreen({super.key,required this.chatRoomID, required this.currentUserUID,required this.contactEmail});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
    final TextEditingController _controller = TextEditingController();
    String? contactName;
    bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContactName();
  }

  Future<void> _loadContactName() async {
    String? name = await getNameByEmail(widget.contactEmail);
    setState(() {
      contactName = name;
      isLoading = false;
    });
  }

 void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      String messageText = _controller.text.trim();

      sendMessage(widget.chatRoomID, widget.currentUserUID, messageText);

      setState(() {
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: isLoading
        ? CircularProgressIndicator()
        : Text('$contactName')
      ),
      body: SafeArea(
        child: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: getMessages(widget.chatRoomID),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                List<Message> messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    bool isSender = message.sender == widget.currentUserUID;
                    return BubbleSpecialThree(
                      text: message.message,
                      color: isSender ? Colors.blue : Colors.grey,
                      isSender: isSender,
                      textStyle: TextStyle(color: Colors.white),
                      tail: true,
                    );
                  },
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