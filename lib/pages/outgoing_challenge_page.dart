import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wizardly_fucked_wizards/other/constants.dart';

class OutgoingChallengePage extends StatelessWidget {
  const OutgoingChallengePage(
      {super.key, required this.changeState, required this.stateChannel});
  final Function changeState;
  final RealtimeChannel stateChannel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Waiting for opponent to accept..."),
            ElevatedButton(
                onPressed: () {
                  cancelChallenge();
                },
                child: const Text("Cancel")),
            const SizedBox(
              height: 300,
            )
          ],
        ),
      ),
    );
  }

  void cancelChallenge() {
    changeState(OpponentPageState.findOpponent);
    stateChannel
        .sendBroadcastMessage(event: 'challenge_cancelled', payload: {});
  }
}
