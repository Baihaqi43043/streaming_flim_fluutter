import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String genre;
  final String imageUrl;

  MovieCard({required this.title, required this.genre, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(imageUrl),
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text('Genre: $genre'),
        ],
      ),
    );
  }
}
