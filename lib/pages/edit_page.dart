import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/movie_service.dart';

class EditPage extends StatefulWidget {
  final Movie movie;

  const EditPage({super.key, required this.movie});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _yearController;
  late TextEditingController _genreController;
  late TextEditingController _directorController;
  late TextEditingController _ratingController;
  late TextEditingController _synopsisController;
  late TextEditingController _imageController;
  late TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.movie.title);
    _yearController = TextEditingController(text: widget.movie.year.toString());
    _genreController = TextEditingController(text: widget.movie.genre);
    _directorController = TextEditingController(text: widget.movie.director);
    _ratingController = TextEditingController(text: widget.movie.rating.toString());
    _synopsisController = TextEditingController(text: widget.movie.synopsis);
    _imageController = TextEditingController(text: widget.movie.image);
    _websiteController = TextEditingController(text: widget.movie.website);
  }

  void _updateMovie() async {
    if (_formKey.currentState!.validate()) {
      final updatedMovie = Movie(
        id: widget.movie.id,
        title: _titleController.text,
        year: _yearController.text,
        genre: _genreController.text,
        director: _directorController.text,
        rating: double.parse(_ratingController.text),
        synopsis: _synopsisController.text,
        
        image: _imageController.text,
        website: _websiteController.text,
      );

      try {
        await MovieService.updateMovie(widget.movie.id, updatedMovie);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Film berhasil diperbarui!")),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal update: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Movie")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_titleController, 'Title'),
              _buildTextField(_yearController, 'Year', type: TextInputType.number),
              _buildTextField(_genreController, 'Genre'),
              _buildTextField(_directorController, 'Director'),
              _buildTextField(_ratingController, 'Rating', type: TextInputType.number),
              _buildTextField(_synopsisController, 'Synopsis'),
              _buildTextField(_imageController, 'Image URL'),
              _buildTextField(_websiteController, 'Website URL'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateMovie,
                child: const Text("Update Movie"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Field tidak boleh kosong' : null,
      ),
    );
  }
}
