import 'package:flutter/material.dart';
import 'package:khtoon/screens/detail_screen.dart';
import 'package:khtoon/widgets/webtoon_image.dart';

class Webtoon extends StatelessWidget {
  final String id, title, thumb;
  const Webtoon({
    super.key,
    required this.id,
    required this.title,
    required this.thumb,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            // Wrap StatelessWidget to look like Page
            MaterialPageRoute(
              builder: (context) =>
                  DetailScreen(id: id, title: title, thumb: thumb),
              // fullscreenDialog: true, // creates new page from under side
            ));
      },
      child: Column(
        children: [
          Hero(
            tag: id,
            child: WebtoonImage(thumb: thumb),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
