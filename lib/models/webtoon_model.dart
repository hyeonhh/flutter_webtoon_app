class WebtoonModel {
  //propety ->  응답을 보면 된다.
  final String title, thumb, id;

  WebtoonModel.fromJson(Map<String, dynamic> json)
      //fromJson named constructor은 map을 받는다.
      : title = json['title'],
        thumb = json['thumb'],
        id = json['id'];
}
