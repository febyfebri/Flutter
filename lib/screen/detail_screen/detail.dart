import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:slicing_1/model/Anime.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailScreen extends StatefulWidget {
  final Anime anime;
  const DetailScreen({super.key, required this.anime});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late YoutubePlayerController _controller;

  @override
void initState() {
    super.initState();
    final String videoId = YoutubePlayer.convertUrlToId(widget.anime.tumbnail) ?? '';
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }
  Widget build(context) {
     return Scaffold(
      appBar: AppBar(
        title: Text(widget.anime.title),
      ),
      body: SafeArea(
        left: false,
        right: false,
      child:SingleChildScrollView(
        padding: EdgeInsets.symmetric( vertical: 10),
        child: Column(
          children: [
            YoutubePlayer(controller: _controller),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(),
              ),
            Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
              child:Center(
                child: Text(widget.anime.description,style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal,fontStyle: FontStyle.italic),textAlign: TextAlign.justify,),
              ),
            )
          ],
        ),
      ),
      ),
    );
  }
}