import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final Color color;
  final bool tail;
  final bool isSender;
  final TextStyle textStyle;

  ChatMessage({
    required this.text,
    required this.color,
    required this.tail,
    this.isSender = true, 
    required this.textStyle,
  });
}

class Message {
  final String sender;
  final String message;
  final Timestamp timestamp;

  Message({required this.sender, required this.message, required this.timestamp});
}
