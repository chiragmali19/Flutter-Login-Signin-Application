import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlayerPage extends StatefulWidget {
  final String title;
  final String artist;
  final String imageUrl;
  final String audioUrl;

  PlayerPage(
      {required this.title,
      required this.artist,
      required this.imageUrl,
      required this.audioUrl});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

 Future<void> _playPause() async {
  if (_isPlaying) {
    await _audioPlayer.pause();
  } else {
    await _audioPlayer.play(widget.audioUrl as Source);
  }
}


  Future<void> _stop() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: widget.imageUrl,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              height: 300,
            ),
            SizedBox(height: 20),
            Text(
              widget.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.artist,
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.skip_previous),
                  onPressed: () {
                    // Implement skip to previous logic
                  },
                ),
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: _playPause,
                ),
                IconButton(
                  icon: Icon(Icons.stop),
                  onPressed: _stop,
                ),
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: () {
                    // Implement skip to next logic
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
