import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/category.dart';

const String API_BASE_URL = 'http://127.0.0.1:8000/api';

class ApiService {
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$API_BASE_URL/categories'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  Future<List<Movie>> fetchMovies(
      {int? categoryId, String? searchQuery}) async {
    String url = '$API_BASE_URL/movies';
    final Map<String, String> params = {};
    if (categoryId != null) params['category_id'] = categoryId.toString();
    if (searchQuery != null) params['search'] = searchQuery;

    if (params.isNotEmpty) {
      url += '?${Uri(queryParameters: params).query}';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  Future<Movie> fetchMovieDetails(int movieId) async {
    final response = await http.get(Uri.parse('$API_BASE_URL/movies/$movieId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Movie.fromJson(data);
    } else {
      throw Exception('Failed to fetch movie details');
    }
  }
}
