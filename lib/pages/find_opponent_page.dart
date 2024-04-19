import 'package:flutter/material.dart';
import 'package:wizardly_fucked_wizards/other/constants.dart';
import 'package:wizardly_fucked_wizards/pages/incoming_challenge_page.dart';
import 'package:wizardly_fucked_wizards/pages/outgoing_challenge_page.dart';

class OpponentChallengePage extends StatefulWidget {
  const OpponentChallengePage({super.key});

  @override
  State<OpponentChallengePage> createState() => _OpponentChallengePageState();
}

class _OpponentChallengePageState extends State<OpponentChallengePage> {
  OpponentPageState _state = OpponentPageState.findOpponent;

  void changeState(OpponentPageState state) {
    setState(() {
      _state = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    late StatelessWidget page;
    switch (_state) {
      case OpponentPageState.findOpponent:
        page = FindOpponentPage();
        break;
      case OpponentPageState.outgoingChallenge:
        page = const OutgoingChallengePage();
        break;
      case OpponentPageState.incomingChallenge:
        page = const IncomingChallengePage();
    }
    return page;
  }
}

class FindOpponentPage extends StatelessWidget {
  FindOpponentPage({super.key});
  final TextEditingController inputFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Hello PlayerName!"),
            TextFormField(
              controller: inputFieldController,
              decoration:
                  const InputDecoration(labelText: ("Enter an opponents name")),
            ),
            ElevatedButton(
                onPressed: () {}, child: const Text("Challenge Opponent")),
            const SizedBox(
              height: 300,
            )
          ],
        ),
      ),
    );
  }
}
