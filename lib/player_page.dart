import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart' as path;

class PlayerPage extends StatefulWidget {
  final List<String> playlist;
  final int initialIndex;

  PlayerPage({required this.playlist, this.initialIndex = 0});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late AudioPlayer _audioPlayer;
  int _currentIndex = 0;
  bool _isPlaying = false;
  double _sliderValue = 0.0;
  Duration _duration = Duration();
  Duration _position = Duration();
  String _currentTitle = '';

  // Define a map to associate each song URL with an asset image path
  final Map<String, String> _imageMap = {
    'song_url_1': 'assets/image1.jpg',
    'song_url_2': 'assets/image2.jpg',
    'song_url_3': 'assets/image3.jpg',
  };

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _audioPlayer = AudioPlayer();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.release();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _initAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        setState(() {
          _isPlaying = true;
        });
      } else if (state == PlayerState.paused || state == PlayerState.stopped) {
        setState(() {
          _isPlaying = false;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
        _sliderValue = _position.inSeconds.toDouble();
      });
    });

    _play(widget.playlist[_currentIndex]);
  }

  void _play(String url) {
    _audioPlayer.play(UrlSource(url));
    _extractTitleFromUrl(url);
  }

  void _pause() {
    _audioPlayer.pause();
  }

  void _stop() {
    _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _position = Duration(seconds: 0);
      _sliderValue = 0.0;
    });
  }

  void _next() {
    if (_currentIndex < widget.playlist.length - 1) {
      _currentIndex++;
      _play(widget.playlist[_currentIndex]);
    }
  }

  void _previous() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _play(widget.playlist[_currentIndex]);
    }
  }

  void _seekToSecond(double second) {
    Duration newPosition = Duration(seconds: second.toInt());
    _audioPlayer.seek(newPosition);
  }

  void _setVolume(double volume) {
    _audioPlayer.setVolume(volume);
  }

  void _extractTitleFromUrl(String url) {
    // Extract the file name from the URL and remove any unwanted characters
    String filename = path.basename(Uri.decodeFull(url));
    int index = filename.lastIndexOf('.');
    String title = index != -1 ? filename.substring(0, index) : filename;
    setState(() {
      _currentTitle = title;
    });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    String currentImageUrl = _imageMap[widget.playlist[_currentIndex]] ??
        'assets/images/homepage.webp';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          color: Colors.deepPurpleAccent,
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Now Playing',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurpleAccent,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.deepPurple, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              // Increase the image size
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(currentImageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: 20), // Decrease space between image and container
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 0, 10), // Reduce padding
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple.shade300,
                      Colors.deepPurple.shade700
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      _currentTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: _previous,
                          icon: Icon(Icons.skip_previous),
                          iconSize: 36.0,
                          color: Colors.white,
                        ),
                        IconButton(
                          onPressed: _isPlaying
                              ? _pause
                              : () => _play(widget.playlist[_currentIndex]),
                          icon:
                              Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                          iconSize: 48.0,
                          color: Colors.white,
                        ),
                        IconButton(
                          onPressed: _next,
                          icon: Icon(Icons.skip_next),
                          iconSize: 36.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            _printDuration(_position),
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                          Expanded(
                            child: Slider(
                              value: _sliderValue,
                              min: 0.0,
                              max: _duration.inSeconds.toDouble(),
                              onChanged: (double value) {
                                setState(() {
                                  _sliderValue = value;
                                });
                                _seekToSecond(value);
                              },
                              activeColor: Colors.deepPurpleAccent,
                              inactiveColor: Colors.grey.shade400,
                            ),
                          ),
                          Text(
                            _printDuration(_duration),
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.volume_down, color: Colors.white),
                        SizedBox(width: 8),
                        Container(
                          width: 150,
                          child: Slider(
                            value: _audioPlayer.volume,
                            min: 0.0,
                            max: 1.0,
                            onChanged: _setVolume,
                            activeColor: Colors.deepPurpleAccent,
                            inactiveColor: Colors.grey.shade400,
                            semanticFormatterCallback: (double value) =>
                                '${(value * 100).round()} %',
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.volume_up, color: Colors.white),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
