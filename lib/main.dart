import 'package:flutter/material.dart';
import 'package:flutter_webtoon_app/screens/home_screen.dart';

void main() {
  // ApiService().getTodaysToons();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  //key를 stateless widget에 보냄

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
