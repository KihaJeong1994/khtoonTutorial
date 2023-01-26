import 'package:flutter/material.dart';
import 'package:khtoon/models/webtoon_detail_model.dart';
import 'package:khtoon/models/webtoon_episode_model.dart';
import 'package:khtoon/services/api_service.dart';

import '../widgets/episode_widget.dart';
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

  // Future<void> _launchUrl(String id) async {
  //   var url =
  //       'https://comic.naver.com/webtoon/detail?titleId=${widget.id}&no=$id';
  //   if (!await launchUrlString(url)) {
  //     throw Exception('Could not launch $url');
  //   }
  // }

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
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 2,
        actions: [
          IconButton(
            onPressed: (() {}),
            icon: const Icon(Icons.favorite_outline_rounded),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
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
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(fontSize: 16),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
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
                    );
                  }
                  return const Text('...');
                },
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: episodes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var episode in snapshot.data!)
                          Episode(widgetId: widget.id, episode: episode)
                      ],
                    );
                    // return Container(
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //       color: Colors.black.withOpacity(0.3),
                    //     ),
                    //     borderRadius: BorderRadius.circular(15),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         blurRadius: 15,
                    //         offset: const Offset(5, -5),
                    //         color: Colors.black.withOpacity(0.1),
                    //       ),
                    //     ],
                    //   ),
                    //   clipBehavior: Clip.hardEdge,
                    //   width: 350,
                    //   child: ListView.separated(
                    //     itemBuilder: (context, index) {
                    //       var episode = snapshot.data![index];
                    //       return Row(
                    //         children: [
                    //           Image.network(
                    //             episode.thumb,
                    //             width: 100,
                    //           ),
                    //           const SizedBox(
                    //             width: 10,
                    //           ),
                    //           Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Text(episode.title),
                    //               const SizedBox(
                    //                 width: 10,
                    //               ),
                    //               Row(
                    //                 children: [
                    //                   Text(episode.rating),
                    //                   const SizedBox(
                    //                     width: 10,
                    //                   ),
                    //                   Text(episode.date),
                    //                 ],
                    //               ),
                    //             ],
                    //           ),
                    //         ],
                    //       );
                    //     },
                    //     itemCount: snapshot.data!.length,
                    //     separatorBuilder: (context, index) => const SizedBox(
                    //       height: 10,
                    //     ),
                    //   ),
                    // );
                  }
                  return const Text('...');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
