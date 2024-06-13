import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'profile_page.dart'; // Import the ProfilePage widget
import 'music_list_page.dart'; // Import the MusicListPage widget
import 'player_page.dart'; // Import the PlayerPage widget
import 'favorite_page.dart'; // Import the FavoritePage widget

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final picker = ImagePicker();
  File? _image;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  int _selectedIndex = 0;
  List<Map<String, String>> _favoriteSongs = [];

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  void _loadProfileImage() async {
    try {
      final String userEmail = FirebaseAuth.instance.currentUser!.email!;
      Reference ref = _storage.ref().child('profile_pictures').child(userEmail);

      // Get the download URL of the file
      final url = await ref.getDownloadURL();
      // Load the image from the URL
      final imageFile = await _getImageFileFromUrl(url);
      // Set the loaded image file to the _image variable
      setState(() {
        _image = imageFile;
      });
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        // Handle case where the file doesn't exist
        print('Profile picture does not exist.');
      } else {
        // Handle other Firebase exceptions
        print('Error loading profile picture: $e');
      }
    }
  }

  Future<File> _getImageFileFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/profile_image.jpg');
    await file.writeAsBytes(bytes.buffer.asUint8List());
    return file;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleFavoriteSong(Map<String, String> song) {
    setState(() {
      if (_favoriteSongs.any((s) => s['title'] == song['title'])) {
        _favoriteSongs.removeWhere((s) => s['title'] == song['title']);
      } else {
        _favoriteSongs.add(song);
      }
    });
  }

  void _unfavoriteSong(Map<String, String> song) {
    setState(() {
      _favoriteSongs.removeWhere((s) => s['title'] == song['title']);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    List<Widget> _widgetOptions = <Widget>[
      MusicListPage(
        onFavoriteToggle: _toggleFavoriteSong,
        favoriteSongs: _favoriteSongs,
      ),
      FavoritePage(
          favoriteSongs: _favoriteSongs, onUnfavorite: _unfavoriteSong),
      ProfilePage(),
      PlayerPage(
        title: _favoriteSongs.isNotEmpty ? _favoriteSongs[0]['title']! : '',
        artist: _favoriteSongs.isNotEmpty ? _favoriteSongs[0]['artist']! : '',
        imageUrl:
            _favoriteSongs.isNotEmpty ? _favoriteSongs[0]['imageUrl']! : '',
        audioUrl:
            _favoriteSongs.isNotEmpty ? _favoriteSongs[0]['audioUrl']! : '',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: GoogleFonts.lobster()),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text(user?.email ?? ''),
              currentAccountPicture: _image == null
                  ? CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey,
                      ),
                    )
                  : CircleAvatar(
                      backgroundImage: FileImage(_image!),
                      radius: 50,
                    ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blue, Colors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: null,
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle settings tap
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: 'Play',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        backgroundColor: Colors.teal,
        onTap: _onItemTapped,
      ),
    );
  }
}
