import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:intl/intl.dart';
import 'package:wizardly_fucked_wizards/pages/game_page/game_page.dart';

class GameCountdownPage extends StatefulWidget {
  const GameCountdownPage({super.key, required this.channelName});
  final String channelName;

  @override
  State<GameCountdownPage> createState() => _GameCountdownPageState();
}

class _GameCountdownPageState extends State<GameCountdownPage> {
  final totalTime = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Countdown(
          interval: const Duration(milliseconds: 10),
          seconds: totalTime,
          build: (BuildContext context, double time) =>
              Stack(alignment: const Alignment(0, 0), children: [
            Text(
              NumberFormat("0", "en_US").format(time).toString(),
              style: const TextStyle(fontSize: 24),
            ),
            SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(
                value: (totalTime.toDouble() - time) / totalTime.toDouble(),
              ),
            )
          ]),
          onFinished: () {
            Get.to(() => GamePage(
                  channelName: widget.channelName,
                ));
          },
        ),
      ),
    );
  }
}
