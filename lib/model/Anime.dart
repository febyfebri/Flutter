class Anime {
  final int id;
  final String image;
  final String title;
  final String description;
  final String tumbnail;

  const Anime({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.tumbnail
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['mal_id'],
      title: json['title'],
      image: json['images']['jpg']['image_url'],
      description: json['synopsis'] ?? 'No description available',
      tumbnail: json['trailer']['youtube_id'] ?? 'No Youtube',
    );
  }
}