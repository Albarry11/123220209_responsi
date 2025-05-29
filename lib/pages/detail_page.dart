import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  final String id;

  const DetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Movie Detail")),
      body: FutureBuilder<Movie>(
        future: MovieService.getMovieById(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Gagal memuat data: ${snapshot.error}"));
          }

          final movie = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    movie.image,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Judul: ${movie.title}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text("Tahun: ${movie.year}"),
                Text("Sutradara: ${movie.director}"),
                Text("Genre: ${movie.genre}"),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text("${movie.rating} / 10"),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "Sinopsis",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(movie.synopsis),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final url = Uri.parse(movie.website);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Gagal membuka website")),
                        );
                      }
                    },
                    child: const Text("Movie Website"),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
