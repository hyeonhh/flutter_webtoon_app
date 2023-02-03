import 'dart:convert';

import 'package:flutter_webtoon_app/models/webtoon_detail_model.dart';
import 'package:flutter_webtoon_app/models/webtoon_episode_model.dart';
import 'package:flutter_webtoon_app/models/webtoon_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://webtoon-crawler.nomadcoders.workers.dev';
  static const String today = "today";

  static Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today'); //저 형태로 url을 가져온다.
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      //여러 Object로 이루어진 리스트
      for (var webtoon in webtoons) {
        //final toon = WebtoonModel.fromJson(webtoon);
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
      }

      return webtoonInstances;
    }

    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);

      ///String 형태인 response.body를 jsonDecode를 통해 JSON 형태로 바꾸어준다.
      ///이를 webtoon에 저장함. 즉 webtoon은 json이다.
      return WebtoonDetailModel.fromJson(webtoon);

      ///이 json을 constructor에 전달한다. 그러면 WebtoonDetialModel은 이 json을 받아서
      ///title에 json의 title 값을 할당하고~ 다른 property에도 동일하게 적용한다.
      //클래스 형태로 바꾸어준다.

    }
    throw Error();
  }

//최신 에피소드를 받아오는 메소드
  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        //새로운 WebtoonEpidsoeModel을 만들어준다.
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }
}
