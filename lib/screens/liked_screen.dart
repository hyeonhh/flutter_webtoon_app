import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikedScreen extends StatefulWidget {
  const LikedScreen({
    super.key,
  });

  @override
  State<LikedScreen> createState() => _LikedScreenState();
}

class _LikedScreenState extends State<LikedScreen> {
  // final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();
  late SharedPreferences prefs;

  Future<List<String>?> getLikedStringList() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');
    return likedToons;
  }

  @override
  void initState() {
    super.initState();
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
        future: getLikedStringList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [for (var toon in snapshot.data!) Text(toon)],
            );
          }
          return const Text('---');
        },
      ),
    );
  }
}
