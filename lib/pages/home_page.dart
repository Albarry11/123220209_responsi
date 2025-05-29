import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';
import 'detail_page.dart';
import 'edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Movie>> _movies;

  @override
  void initState() {
    super.initState();
    _movies = MovieService.getAllMovies();
  }

  void _refreshMovies() {
    setState(() {
      _movies = MovieService.getAllMovies();
    });
  }

  void _deleteMovie(String id) async {
    try {
      await MovieService.deleteMovie(id);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Movie berhasil dihapus")));
      _refreshMovies();
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menghapus: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halo, 123220209!'),
        actions: [
          // You can add other AppBar actions here if needed
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: _movies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }

          final movies = snapshot.data!;
          if (movies.isEmpty) {
            return const Center(child: Text("Belum ada data film"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Image.network(
                    movie.image,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text("${movie.title} (${movie.year})"),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text("${movie.rating}"),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(id: movie.id),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditPage(movie: movie),
                            ),
                          ).then((_) => _refreshMovies());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteMovie(movie.id),
                      ),
                    ],
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
