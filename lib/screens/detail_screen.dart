import 'package:flutter/material.dart';
import 'package:flutter_webtoon_app/models/webtoon_detail_model.dart';
import 'package:flutter_webtoon_app/models/webtoon_episode_model.dart';
import 'package:flutter_webtoon_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/episode_widget.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> edpisodes;
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    //이렇게 하면 Instances 가 만들어졌고, 사용자의 저장소엔 connection이 생긴 것이다.

    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      /// 이미 list가 있다는 의미이다.
      ///사용자가 지금 보고 있는 webtoon의 ID가 likedToons 안에 있는지 없는지를 확인해야한다.
      if (likedToons.contains(widget.id) == true) {
        setState(() {
          isLiked = true;
        });
      }
    } else {
      //likedToons String list를 만들어준다.
      ///사용자가 처음으로 앱을 실행하는 케이스 : likedToons는 존재하지 않는다.
      await prefs.setStringList('likedToons', []);
    }
  }

  ///late: 초기화 하고 싶은 property가 있지만 constructor에서는 불가능한 경우
  ///initState()에서 초기화해준다. 그런데 iniiState() 는 build보다 항상 먼저 호출된다.
  ///한번만 호출된다.

  @override
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    edpisodes = ApiService.getLatestEpisodesById(widget.id);
    initPrefs();
  }

  onHeartsTap() async {
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      ///webtoon이 likedToons에 없으면 추가해줘야 한다. 이미 있다면 삭제
      if (isLiked) {
        //likedToonsList에서 webtoon을 지워준다.
        likedToons.remove(widget.id);
      } else {
        likedToons.add(widget.id);
      }
      await prefs.setStringList('likedToons', likedToons);

      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        actions: [
          IconButton(
            ///좋아요를 누르거나 취소 할 수 있어야 한다.
            onPressed: onHeartsTap,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_outline,
            ),
          ),
        ],
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: widget.id,
                  child: Container(
                    width: 250,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 15,
                              offset: const Offset(10, 0),
                              color: Colors.black.withOpacity(0.5))
                        ]),
                    child: Image.network(widget.thumb),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
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
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        '${snapshot.data!.genre} / ${snapshot.data!.age}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  );
                }

                return const Text('...');
              },
            ),
            const SizedBox(
              height: 25,
            ),
            FutureBuilder(
              future: edpisodes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //에피소드 리스트를 어떻게 렌더링할까 ?
                  return Column(
                    //Column으로 하는 이유 : 10개이고, ListView는 다소 복잡하다.
                    children: [
                      for (var episode in snapshot.data!)
                        Episode(episode: episode, webtoonId: widget.id)
                    ],
                  );
                }
                return Container();
              },
            ),
          ]),
        ),
      ),
    );
  }
}
