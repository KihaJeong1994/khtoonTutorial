import 'package:flutter/material.dart';
import 'package:khtoon/models/webtoon_model.dart';
import 'package:khtoon/services/api_service.dart';
import 'package:khtoon/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Today\'s 툰s',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 2,
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    itemBuilder: (context, index) {
                      var webtoon = snapshot.data![index];
                      return Webtoon(
                        id: webtoon.id,
                        title: webtoon.title,
                        thumb: webtoon.thumb,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 40),
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
