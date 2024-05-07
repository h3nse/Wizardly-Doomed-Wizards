import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:wizardly_fucked_wizards/main.dart';
import 'package:wizardly_fucked_wizards/other/player.dart';
import 'package:wizardly_fucked_wizards/other/words_for_names.dart';
import 'package:wizardly_fucked_wizards/pages/find_opponent_page.dart';

class FrontPage extends StatelessWidget {
  const FrontPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 100),
              child: Text(
                "Wizardly Doomed Wizards",
                style: TextStyle(fontSize: 25),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (Player().name == '') {
                  _createPlayer();
                }
                Get.to(const OpponentChallengePage());
              },
              child: const Text("PLAY"),
            )
          ],
        ),
      ),
    );
  }

  void _createPlayer() async {
    String name;
    int id;
    while (true) {
      try {
        name = _generateName();
        Random random = Random();
        id = random.nextInt(10000);
        Player().name = name;
        Player().id = id;
        await supabase.from('players').insert({'id': id, 'name': name});
        break;
      } catch (_) {}
    }
  }

  String _generateName() {
    Random random = Random();
    final name =
        '${Words.firstWords[random.nextInt(Words.firstWords.length)]}${Words.secondWords[random.nextInt(Words.secondWords.length)]}';
    return name;
  }
}
