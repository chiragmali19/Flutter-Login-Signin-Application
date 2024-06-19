import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'player_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _uploadedSongs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUploadedSongs();
  }

  void _fetchUploadedSongs() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('songs').get();
      List<Map<String, dynamic>> songs = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'] ?? '',
          'artist': doc['artist'] ?? 'Unknown Artist',
          'audioUrl': doc['audioUrl'] ?? '',
        };
      }).toList();

      setState(() {
        _uploadedSongs = songs;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching songs: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _playSong(int index) {
    List<String> playlist =
        _uploadedSongs.map((song) => song['audioUrl'] as String).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerPage(
          playlist: playlist,
          initialIndex: index,
        ),
      ),
    );
  }

  void _refreshHomePage() {
    setState(() {
      _isLoading = true;
    });
    _fetchUploadedSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              color: Colors.deepPurpleAccent,
              icon: Icon(
                Icons.menu,
                size: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text(
          'Music World',
          style: GoogleFonts.lobster(
            fontSize: 30,
            color: Colors.deepPurpleAccent,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.deepPurpleAccent,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.deepPurpleAccent),
            onPressed: _refreshHomePage,
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.deepPurple, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.play_arrow, color: Colors.deepPurpleAccent),
                title: Text(
                  'Music Player',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if (_uploadedSongs.isNotEmpty) {
                    _playSong(0);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.person, color: Colors.deepPurpleAccent),
                title: Text(
                  'Profile',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.deepPurpleAccent),
                title: Text(
                  'Settings',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Divider(
                color: Colors.white,
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.deepPurpleAccent),
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  await _auth.signOut();
                  Navigator.pushNamed(context, '/');
                },
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _uploadedSongs.isEmpty
              ? Center(
                  child: Text(
                    'No songs available.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.deepPurple, Colors.black],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: _uploadedSongs.length,
                    itemBuilder: (context, index) {
                      final song = _uploadedSongs[index];
                      return GestureDetector(
                        onTap: () => _playSong(index),
                        child: Card(
                          color: Colors.black54.withOpacity(0.6),
                          elevation: 8,
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'assets/images/music-player.png', // Placeholder image
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              song['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              song['artist'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            trailing:
                                Icon(Icons.music_note, color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
