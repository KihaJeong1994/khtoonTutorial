import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:khtoon/models/webtoon_episode_model.dart';
import 'package:khtoon/models/webtoon_model.dart';

import '../models/webtoon_detail_model.dart';

class ApiService {
  static const String baseUrl =
      'https://webtoon-crawler.nomadcoders.workers.dev';
  static const String today = "today";
  static const String episodes = "episodes";

  // http.get() method's return type is Future<Response>
  // this means it will return 'Response' class at the future.
  // we don't want to just pass this method's return value, but we want to use this result after response arrive
  // => use 'await' to wait for Response to return. To use 'await', you must define this method is async method
  // if you use 'await', the return type is not Future<Response>, but Response
  static Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> webtoonsJson = jsonDecode(response.body);
      for (var webtoon in webtoonsJson) {
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
      }
      return webtoonInstances;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(json);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    final url = Uri.parse('$baseUrl/$id/$episodes');
    final response = await http.get(url);
    List<WebtoonEpisodeModel> episodeInstances = [];
    if (response.statusCode == 200) {
      final episodesJson = jsonDecode(response.body);
      for (var episode in episodesJson) {
        episodeInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodeInstances;
    }
    throw Error();
  }
}
