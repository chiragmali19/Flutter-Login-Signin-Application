import 'package:flutter/material.dart';
import 'player_page.dart';

class FavoritePage extends StatelessWidget {
  final List<Map<String, String>> favoriteSongs;
  final Function(Map<String, String>) onUnfavorite;

  FavoritePage({required this.favoriteSongs, required this.onUnfavorite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Songs'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: favoriteSongs.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.music_note),
            title: Text(favoriteSongs[index]['title']!),
            subtitle: Text(favoriteSongs[index]['artist']!),
            trailing: IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                onUnfavorite(favoriteSongs[index]);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerPage(
                    title: favoriteSongs[index]['title']!,
                    artist: favoriteSongs[index]['artist']!,
                    imageUrl: favoriteSongs[index]['imageUrl']!,
                    audioUrl: favoriteSongs[index]['audioUrl']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
