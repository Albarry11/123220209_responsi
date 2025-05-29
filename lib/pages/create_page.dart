import 'package:flutter/material.dart';
import '../services/movie_service.dart';
import '../models/movie_model.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _synopsisController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  void _submitMovie() async {
    if (_formKey.currentState!.validate()) {
      final newMovie = Movie(
        id: '', // ID akan di-generate oleh server
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
        await MovieService.createMovie(newMovie);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Film berhasil ditambahkan!')),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan film: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Movie")),
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
                onPressed: _submitMovie,
                child: const Text("Submit New Movie"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Field tidak boleh kosong' : null,
      ),
    );
  }
}
