class WebtoonDetailModel {
  //property를 정의하자
  final String title, about, genre, age;

  //Constructor
  WebtoonDetailModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        about = json['about'],
        genre = json['genre'],
        age = json['age'];
}
