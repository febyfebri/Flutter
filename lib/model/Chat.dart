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
