import 'package:flutter/material.dart';

class MusicListPage extends StatelessWidget {
  final Function(Map<String, String>) onFavoriteToggle;
  final List<Map<String, String>> favoriteSongs;

  MusicListPage({required this.onFavoriteToggle, required this.favoriteSongs});

  // List of online music with posters
  // final List<Map<String, String>> onlineMusicList = [
  //   // Add your list of songs here
  // ];
  final List<Map<String, String>> onlineMusicList = [
    {
      'title': 'Song 1',
      'artist': 'Artist 1',
      'imageUrl': 'https://example.com/poster1.jpg',
      'audioUrl': 'https://example.com/audio1.mp3',
    },
    {
      'title': 'Song 2',
      'artist': 'Artist 2',
      'imageUrl': 'https://example.com/poster2.jpg',
      'audioUrl': 'https://example.com/audio2.mp3',
    },
    // Add more online songs here...
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: onlineMusicList.length,
      itemBuilder: (context, index) {
        final song = onlineMusicList[index];
        return ListTile(
          leading: Image.network(
            song['imageUrl'] ?? '', // Use imageUrl for the poster
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(song['title'] ?? ''),
              ),
              IconButton(
                icon: Icon(
                  Icons.favorite_border_outlined,
                  color: favoriteSongs.contains(song) ? Colors.red : null,
                ),
                onPressed: () {
                  // Toggle favorite state
                  onFavoriteToggle(song);
                },
              ),
            ],
          ),
          subtitle: Text(song['artist'] ?? ''),
          onTap: () {
            // Handle onTap event
          },
        );
      },
    );
  }
}
