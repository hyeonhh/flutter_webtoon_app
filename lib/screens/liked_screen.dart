import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/webtoon_model.dart';
import '../services/api_service.dart';
import '../widgets/liked_widget.dart';

class LikedScreen extends StatefulWidget {
  const LikedScreen({super.key});

  @override
  State<LikedScreen> createState() => _LikedScreenState();
}

class _LikedScreenState extends State<LikedScreen> {
  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  Future<void> getLikedList() async {
    final prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');
    print(likedToons);
  }

  @override
  void initState() {
    super.initState();
    getLikedList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: const Text(
          '좋아요 목록',
          style: TextStyle(
            color: Colors.green,
            fontSize: 25,
          ),
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
                Expanded(
                  child: makeText(context, snapshot),
                ),
                //Text(likedToons!.first)
                //const Icon(Icons.favorite_outline),
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
        scrollDirection: Axis.vertical,
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          //ListView의 아이템을 만드는 역할 : itemBuidler
          //  print(index);
          var webtoon = snapshot.data![index];
          return Liked(
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
