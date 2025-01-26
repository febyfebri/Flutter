import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:slicing_1/model/Anime.dart';
import 'package:slicing_1/screen/detail_screen/detail.dart';
import '../../network/api.dart';

class ListAnime extends StatefulWidget {
  const ListAnime({super.key});

  @override
  State<ListAnime> createState() => _ListAnime();
}

class _ListAnime extends State<ListAnime> {
  late Future<List<Anime>> animeList;

  @override
  void initState() {
    super.initState();
    animeList = fetchAnime();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Top Anime'),
        ),
      body: FutureBuilder<List<Anime>>(
        future: animeList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Skeletonizer(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading:const Icon(Icons.person), 
                      title: Text('Item number $index as title'),
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Anime Found'));
          }
          final animes = snapshot.data!;
          return ListView.builder(
            itemCount: (animes.length / 2).ceil(),
            itemBuilder: (context, index) {
              final firstAnime = animes[index * 2];
              final secondAnime = 
                  index * 2 + 1 < animes.length ? animes[index * 2 + 1] : null;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(anime: firstAnime),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              Image.network(
                                firstAnime.image,
                                width: 150,
                              ),
                              SizedBox(height: 8.0),
                              SizedBox(
                                width: 150,
                                child:Center(
                                  child: Text(
                                    firstAnime.title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                      ),
                    ),
                    if (secondAnime != null)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(anime: secondAnime),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              Image.network(
                                secondAnime.image,
                                width: 150,
                              ),
                              SizedBox(height: 8.0),
                              SizedBox(
                                width: 150,
                                child:Center(
                                  child: Text(
                                    secondAnime.title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}