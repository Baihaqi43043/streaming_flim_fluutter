import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../services/api_service.dart';
import '../models/movie.dart';
import '../models/category.dart';
import '../widgets/movie_detail_modal.dart';
import '../services/video_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<Category> _categories = [];
  List<Movie> _movies = [];
  int? _selectedCategoryId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final categories = await _apiService.fetchCategories();
      final movies = await _apiService.fetchMovies();
      setState(() {
        _categories = categories;
        _movies = movies;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void _showMovieDetails(int movieId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final movie = await _apiService.fetchMovieDetails(movieId);
      setState(() {
        _isLoading = false;
      });

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => MovieDetailModal(movie: movie),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching movie details: $e');
    }
  }

  Future<void> _filterMovies() async {
    setState(() {
      _isLoading = true;
    });

    final movies = await _apiService.fetchMovies(
      categoryId: _selectedCategoryId,
      searchQuery: _searchController.text,
    );

    setState(() {
      _movies = movies;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Streaming Film'),
        backgroundColor: Colors.black,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Filter kategori
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _categories.map((category) {
                        final isSelected = category.id == _selectedCategoryId;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategoryId =
                                  isSelected ? null : category.id;
                            });
                            _filterMovies();
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue : Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                category.name,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Filter pencarian
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Cari film...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _filterMovies,
                        child: Text('Cari'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Daftar film
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _movies.length,
                      itemBuilder: (context, index) {
                        final movie = _movies[index];
                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Gunakan video_thumbnail untuk menampilkan thumbnail
                              Expanded(
                                child: FutureBuilder<Uint8List?>(
                                  future: VideoService()
                                      .generateThumbnail(movie.videoUrl),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child:
                                              CircularProgressIndicator()); // Loading spinner
                                    } else if (snapshot.hasError ||
                                        snapshot.data == null) {
                                      return Container(
                                        color: Colors.grey,
                                        child: Center(
                                          child: Icon(Icons.movie,
                                              size: 50,
                                              color:
                                                  Colors.white), // Placeholder
                                        ),
                                      );
                                    } else {
                                      return Image.memory(
                                        snapshot.data!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      );
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  movie.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ElevatedButton(
                                  onPressed: () => _showMovieDetails(
                                      movie.id), // Tampilkan modal
                                  child: Text('Detail'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
