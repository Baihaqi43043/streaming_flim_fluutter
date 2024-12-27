class Movie {
  final int id;
  final String title;
  final String genre;
  final String videoUrl;
  final String description;
  final int duration;
  final String releaseYear;
  final int rating;

  Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.videoUrl,
    required this.description,
    required this.duration,
    required this.releaseYear,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: int.tryParse(json['id'].toString()) ??
          0, // Pastikan 'id' dikonversi ke int
      title: json['title'] ?? '',
      genre: json['genre'] ?? '',
      videoUrl: json['video_url'] ?? '',
      description: json['deskripsi'] ?? '',
      duration: int.tryParse(json['duration'].toString()) ??
          0, // Pastikan 'duration' dikonversi ke int
      releaseYear: json['release_year'].toString(), // Simpan sebagai string
      rating: int.tryParse(json['rating'].toString()) ??
          0, // Pastikan 'rating' dikonversi ke int
    );
  }
}
