import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slicing_1/network/Firestore.dart';
import 'package:slicing_1/screen/chat_screen/chat_screen.dart';

class CustomModal extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onAddContact;

  CustomModal({required this.controller, required this.onAddContact});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Message'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Enter Email or Name',
              hintText: 'Contact Name or Email',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              String contact = controller.text.trim();
              if (contact.isNotEmpty) {
                bool isRegistered = await isEmailRegistered(contact);
                if (isRegistered) {
                  final currentEmail = FirebaseAuth.instance.currentUser?.email ?? "";
                  String chatRoomID = generateChatRoom(currentEmail, contact);
                  String currentUID = FirebaseAuth.instance.currentUser!.uid;
                  try {
                    await createChatRoom(currentEmail, contact);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Chat Room Created with $contact')),
                    );
                      Navigator.of(context).pop();
                      
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(contactEmail: contact,chatRoomID: chatRoomID,currentUserUID: currentUID,)
                      ),
                    );
                  } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Email Tidak Terdaftar')),
                );                
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter email')),
                );
              }
            },
            child: Text('Chat'),
          ),
        ],
      ),
    );
  }
}
