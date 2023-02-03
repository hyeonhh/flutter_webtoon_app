import 'package:flutter/material.dart';

import '../models/webtoon_model.dart';
import '../services/api_service.dart';

class LikedScreen extends StatelessWidget {
  //final String title, id;

  // LikedScreen(
  //   this.title,
  //   this.id,
  // );
  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.green,
      title: const Text(
        '좋아요 목록',
        style: TextStyle(
          color: Colors.green,
          fontSize: 25,
        ),
      ),
      centerTitle: true,
    ));
  }
}
