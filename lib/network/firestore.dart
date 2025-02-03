import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slicing_1/model/Chat.dart';

Future<void> saveUser(User user) async {
  try {
    if (user.displayName == null || user.email == null || user.photoURL == null) {
      throw Exception("User data is incomplete");
    }
    final userRef = FirebaseFirestore.instance.collection('user').doc(user.uid);
    await userRef.set({
      'nama': user.displayName ?? 'No name',
      'email': user.email ?? 'No email',
      'photo': user.photoURL ?? 'No photo',
    });
  } catch (e) {
    throw Exception("Failed to save user data");
  }
}

Future<bool> isEmailRegistered(String email) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .get();

    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    print('Error checking email: $e');
    return false;
  }
}

Future<String?> getNameByEmail(String email) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('user') 
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userDoc = querySnapshot.docs.first;
      return userDoc['nama'];
    } else {
      return null;
    }
  } catch (e) {
    print('Error getting name: $e');
    return null;
  }
}


Future<void> createChatRoom(String userEmail, String contactEmail) async {
  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final currentUserId = currentUser.uid;

      bool isRegistered = await isEmailRegistered(contactEmail);
      if (!isRegistered) {
        throw Exception('The contact email is not registered.');
      }

      String chatRoomId = '';
      if (currentUser.email != null && userEmail.isNotEmpty && contactEmail.isNotEmpty) {
        chatRoomId = (currentUser.email!.compareTo(contactEmail) < 0)
            ? '${currentUser.email}-$contactEmail'
            : '$contactEmail-${currentUser.email}';
      }

      await FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId).set({
        'participants': [currentUser.email, contactEmail],
        'lastMessage': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Chat room created: $chatRoomId');
    }
  } catch (e) {
    print('Error creating chat room: $e');
    throw Exception("Failed to create chat room");
  }
}


Future<void> sendMessage(String chatRoomID, String senderUID, String message) async {
  try {
    String messageID = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomID)
        .collection('messages')
        .doc(messageID)
        .set({
      'sender': senderUID,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
    await FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomID).update({
      'lastMessage': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print('Error sending message: $e');
  }
}

String generateChatRoom(String email1, String email2) {
    List<String> emails = [email1, email2];
    emails.sort();
    return '${emails[0]}-${emails[1]}';
  }

Stream<List<Message>> getMessages(String chatRoomID) {
  return FirebaseFirestore.instance
      .collection('chatRooms')
      .doc(chatRoomID)
      .collection('messages')
      .orderBy('timestamp')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return Message(
        sender: doc['sender'],
        message: doc['message'],
        timestamp: doc['timestamp'],
      );
    }).toList();
  });
}



