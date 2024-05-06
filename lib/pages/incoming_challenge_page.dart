import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
                ElevatedButton(onPressed: () {}, child: const Text("Accept"))
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
    reset();
    stateChannel.sendBroadcastMessage(
        event: 'challenge_rejected', payload: {'challengerId': challengerId});
  }
}
