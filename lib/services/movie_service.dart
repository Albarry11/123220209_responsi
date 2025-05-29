import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

class MovieService {
  static const String baseUrl =
      'https://tpm-api-responsi-a-h-872136705893.us-central1.run.app/api/v1';

  static Future<List<Movie>> getAllMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/movies'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];
      return data.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data');
    }
  }

  static Future<Movie> getMovieById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/movies/$id'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final movieData = json['data'];
      return Movie.fromJson(movieData);
    } else {
      throw Exception('Gagal mengambil data');
    }
  }

  static Future<void> createMovie(Movie movie) async {
    final response = await http.post(
      Uri.parse('$baseUrl/movies'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "title": movie.title,
        "year": movie.year,
        "genre": movie.genre,
        "director": movie.director,
        "rating": movie.rating,
        "synopsis": movie.synopsis,
        "image": movie.image,
        "website": movie.website,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Gagal menambahkan movie");
    }
  }

  static Future<void> updateMovie(String id, Movie movie) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/movies/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "title": movie.title,
        "year": movie.year,
        "genre": movie.genre,
        "director": movie.director,
        "rating": movie.rating,
        "synopsis": movie.synopsis,
        "image": movie.image,
        "website": movie.website,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal update movie');
    }
  }

  static Future<void> deleteMovie(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/movies/$id"));
    if (response.statusCode != 200) throw Exception("Gagal menghapus data");
  }
}
