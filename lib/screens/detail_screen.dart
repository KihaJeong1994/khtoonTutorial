import 'package:flutter/material.dart';
import 'package:khtoon/models/webtoon_detail_model.dart';
import 'package:khtoon/models/webtoon_episode_model.dart';
import 'package:khtoon/services/api_service.dart';

import '../widgets/webtoon_image.dart';

class DetailScreen extends StatefulWidget {
  final String id, title, thumb;
  const DetailScreen({
    super.key,
    required this.id,
    required this.title,
    required this.thumb,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel>
      webtoon; // you cannot initialize variable with parent's field(widget.id) here => use 'late' modifier to initialize later
  late Future<List<WebtoonEpisodeModel>> episodes;

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 2,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: widget.id,
                child: WebtoonImage(thumb: widget.thumb),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder(
            future: webtoon,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!.about,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        '${snapshot.data!.genre} / ${snapshot.data!.age}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const Text('...');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder(
              future: episodes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    width: 350,
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        var episode = snapshot.data![index];
                        return Row(
                          children: [
                            Image.network(
                              episode.thumb,
                              width: 100,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Text(episode.title),
                                const SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  children: [
                                    Text(episode.rating),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(episode.date),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                      itemCount: snapshot.data!.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                    ),
                  );
                }
                return const Text('...');
              },
            ),
          ),
        ],
      ),
    );
  }
}
