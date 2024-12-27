import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieDetailModal extends StatelessWidget {
  final Movie movie;

  MovieDetailModal({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Genre: ${movie.genre}'),
          Text('Durasi: ${movie.duration} menit'),
          Text('Tahun Rilis: ${movie.releaseYear}'),
          SizedBox(height: 8),
          Text('Deskripsi:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(movie.description),
          SizedBox(height: 16),
          if (movie.videoUrl != null)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black,
                child: Center(
                  child: Text(
                    'Video player placeholder',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
