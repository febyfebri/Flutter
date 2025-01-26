import 'package:flutter/material.dart';
import 'package:slicing_1/screen/chat_screen/chat_screen.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context)=> ChatScreen()));
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                           Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage('https://images.unsplash.com/photo-1505968409348-bd000797c92e?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                                  fit: BoxFit.cover
                                )
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ini Nama",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                Text(
                                  "Ini Pesan Masuk",
                                  style: TextStyle(color: Colors.blueGrey.shade200),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                            ),
                );
        },
      ),
    );
  }
}