import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wizardly_fucked_wizards/main.dart';
import 'package:wizardly_fucked_wizards/other/player.dart';
import 'package:wizardly_fucked_wizards/pages/game_countdown_page.dart';

class IncomingChallengePage extends StatelessWidget {
  const IncomingChallengePage(
      {super.key,
      required this.changeState,
      required this.challengerId,
      required this.challengerName,
      required this.reset,
      required this.stateChannel});
  final Function changeState;
  final int challengerId;
  final String challengerName;
  final Function reset;
  final RealtimeChannel stateChannel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("You are being challenged by $challengerName"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      rejectChallenge();
                    },
                    child: const Text("Reject")),
                ElevatedButton(
                    onPressed: () {
                      acceptChallenge();
                      // channelName is a combination of the two players' ids
                      final String channelName =
                          challengerId.toString() + Player().id.toString();
                      Get.to(() => GameCountdownPage(
                            channelName: channelName,
                          ));
                    },
                    child: const Text("Accept"))
              ],
            ),
            const SizedBox(
              height: 300,
            )
          ],
        ),
      ),
    );
  }

  void rejectChallenge() {
    stateChannel.sendBroadcastMessage(
        event: 'challenge_rejected', payload: {'challengerId': challengerId});
    reset();
  }

  void acceptChallenge() {
    Player().opponentId = challengerId;
    supabase.from('players').update({'opponent_id': Player().opponentId});
    stateChannel.sendBroadcastMessage(
        event: 'challenge_accepted',
        payload: {'challengerId': challengerId, 'recieverId': Player().id});
  }
}
