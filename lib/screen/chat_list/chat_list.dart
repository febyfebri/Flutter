import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slicing_1/components/modal_contact.dart';
import 'package:slicing_1/network/Firestore.dart';
import 'package:slicing_1/screen/chat_screen/chat_screen.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> chatRooms = [];
  Map<String, String> userNames = {};


Future<void> fetchChatRooms() async {
  final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  if (currentUserEmail == null) return;

  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('chatRooms')
        .where('participants', arrayContains: currentUserEmail)
        .get();

    List<Map<String, dynamic>> rooms = snapshot.docs.map((doc) => {
          'chatRoomId': doc.id,
          'lastMessage': doc['lastMessage'] ?? '',
          'participants': doc['participants']
        }).toList();

    for (var room in rooms) {
      List<dynamic> participants = room['participants'];
      String otherEmail = participants.firstWhere(
        (email) => email != currentUserEmail,
        orElse: () => "",
      );

      if (otherEmail.isNotEmpty && !userNames.containsKey(otherEmail)) {
        userNames[otherEmail] = (await getNameByEmail(otherEmail))!;
      }
    }

    setState(() {
      chatRooms = rooms;
    });
  } catch (e) {
    print("Error fetching chat rooms: $e");
  }
}


  @override
  void initState() {
    super.initState();
    fetchChatRooms();
  }

  void _showCustomModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomModal(
          controller: _controller,
          onAddContact: (String contact) {
            setState(() {
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
        final currentEmail = FirebaseAuth.instance.currentUser?.email ?? "";
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          IconButton(
              onPressed: () => _showCustomModal(context), icon: Icon(Icons.add))
        ],
        automaticallyImplyLeading: false,
      ),
      body: chatRooms.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                final chatRoom = chatRooms[index];
                final chatRoomId = chatRoom['chatRoomId'];
                final lastMessage = chatRoom['lastMessage'];
                final participants = chatRoom['participants'];

                String otherEmail = participants.firstWhere(
                  (email) => email != currentEmail,
                  orElse: () => "",
                );
                String displayName = userNames[otherEmail] ?? otherEmail;


                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          contactEmail: participants.firstWhere(
                              (email) => email != FirebaseAuth.instance.currentUser!.email),
                          currentUserUID: FirebaseAuth.instance.currentUser!.uid,
                          chatRoomID: chatRoomId,
                        ),
                      ),
                    );
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
                                image: NetworkImage(
                                    'https://images.unsplash.com/photo-1505968409348-bd000797c92e?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$displayName',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  lastMessage ?? 'No message',
                                  style: TextStyle(color: Colors.blueGrey.shade200),
                                ),
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