import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://webtoon-crawler.nomadcoders.workers.dev';
  final String today = "today";

  void getTodaysToons() async {
    final url = Uri.parse('$baseUrl/$today'); //저 형태로 url을 가져온다.
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      return;
    }

    throw Error();
  }
}
