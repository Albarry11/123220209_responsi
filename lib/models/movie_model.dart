class Movie {
  final String id;
  final String title;
  final String director;
  final String genre;
  final String year;
  final double rating;
  final String image;
  final String synopsis;
  final String website;

  Movie({
    required this.id,
    required this.title,
    required this.director,
    required this.genre,
    required this.year,
    required this.rating,
    required this.image,
    required this.synopsis,
    required this.website,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
  return Movie(
    id: json['_id'] ?? '',
    title: json['title'] ?? '',
    director: json['director'] ?? '',
    genre: json['genre'] ?? '',
    year: json['year']?.toString() ?? '',
    rating: double.tryParse(json['rating']?.toString() ?? '') ?? 0.0,
    image: json['image'] ?? '',
    synopsis: json['synopsis'] ?? '',
    website: json['website'] ?? '',
  );
}

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "director": director,
      "genre": genre,
      "year": year,
      "rating": rating,
      "image": image,
      "synopsis": synopsis,
      "website": website,
    };
  }
}
