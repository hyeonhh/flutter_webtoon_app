import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webtoon_app/models/webtoon_model.dart';
import 'package:flutter_webtoon_app/services/api_service.dart';
import 'package:flutter_webtoon_app/widgets/webtoon_widget.dart';

import 'liked_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  //만들어준 Future을 넣어줌.
  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: const Text(
          '오늘의 웹툰',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LikedScreen()));
          },
        ),
      ),
      body: FutureBuilder(
        future: webtoons, //자기가 기다릴 future
        builder: (context, snapshot) {
          //snapshot을 통해 Future가 로딩 중인지 데이터를 받았는지, 오류가 났는 지 알 수 있음
          if (snapshot.hasData) {
            //future 동작 끝나고 서버에 응답했을 때만 실행됨
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: makeText(context, snapshot),
                )
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

  ScrollConfiguration makeText(
      BuildContext context, AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
        },
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          //ListView의 아이템을 만드는 역할 : itemBuidler
          //  print(index);
          var webtoon = snapshot.data![index];
          return Webtoon(
            title: webtoon.title,
            thumb: webtoon.thumb,
            id: webtoon.id,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 40),
      ),
    );
  }
}
