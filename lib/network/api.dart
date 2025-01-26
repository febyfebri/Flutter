import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:slicing_1/model/Anime.dart';

Future<List<Anime>> fetchAnime() async {
  final response = await http.get(Uri.parse('https://api.jikan.moe/v4/top/anime'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    return (data['data'] as List).map((json) => Anime.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load anime');
  }
}
