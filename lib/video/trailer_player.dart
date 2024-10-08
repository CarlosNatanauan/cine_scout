import 'package:flutter/material.dart';
import 'package:webviewtube/webviewtube.dart';

class TrailerPlayer extends StatefulWidget {
  final String videoKey; // YouTube video key

  const TrailerPlayer({Key? key, required this.videoKey}) : super(key: key);

  @override
  _TrailerPlayerState createState() => _TrailerPlayerState();
}

class _TrailerPlayerState extends State<TrailerPlayer> {
  late WebviewtubeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebviewtubeController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewtubeVideoPlayer(
      videoId: widget.videoKey,
      controller: _controller,
      options: const WebviewtubeOptions(
        forceHd: true,
        enableCaption: false,
      ),
    );
  }
}
