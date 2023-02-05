import 'package:flutter/material.dart';

import '../screens/detail_screen.dart';

class Liked extends StatelessWidget {
  final String title, thumb, id;

  const Liked({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => DetailScreen(
                    title: title,
                    thumb: thumb,
                    id: id,
                  )),
              fullscreenDialog: true,
            ));
      }),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(
            height: 20,
          ),

          Text(
            id,
          ),
          //const Icon(Icons.favorite_outline)
        ],
      ),
    );
  }
}
