import 'package:flutter/material.dart';
import 'package:slicing_1/model/Chat.dart';

List<ChatMessage> chatMessages = [
  ChatMessage(
    text: 'Added iMessage shape bubbles',
    color: Color(0xFF1B97F3),
    tail: false,
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
  ),
  ChatMessage(
    text: 'Please try and give some feedback on it!',
    color: Color(0xFF1B97F3),
    tail: true,
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
  ),
  ChatMessage(
    text: 'Sure',
    color: Color(0xFFE8E8EE),
    tail: false,
    isSender: false,
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
  ),
  ChatMessage(
    text: "I tried. It's awesome!!!",
    color: Color(0xFFE8E8EE),
    tail: false,
    isSender: false,
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
  ),
  ChatMessage(
    text: "Thanks",
    color: Color(0xFFE8E8EE),
    tail: true,
    isSender: false,
    textStyle: TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
  ),
];
