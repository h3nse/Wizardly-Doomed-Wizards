import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wizardly_fucked_wizards/main.dart';
import 'package:wizardly_fucked_wizards/other/constants.dart';
import 'package:wizardly_fucked_wizards/other/player.dart';
import 'package:wizardly_fucked_wizards/pages/game_countdown_page.dart';
import 'package:wizardly_fucked_wizards/pages/game_page/game_page.dart';
import 'package:wizardly_fucked_wizards/pages/incoming_challenge_page.dart';
import 'package:wizardly_fucked_wizards/pages/outgoing_challenge_page.dart';

class OpponentChallengePage extends StatefulWidget {
  const OpponentChallengePage({super.key});

  @override
  State<OpponentChallengePage> createState() => _OpponentChallengePageState();
}

class _OpponentChallengePageState extends State<OpponentChallengePage> {
  OpponentPageState _state = OpponentPageState.findOpponent;
  late final RealtimeChannel stateChannel;
  String _challengerName = '';
  int _challengerId = 0;

  @override
  Widget build(BuildContext context) {
    late Widget page;
    switch (_state) {
      case OpponentPageState.findOpponent:
        page = FindOpponentPage(
          changeState: changeState,
          stateChannel: stateChannel,
        );
        break;
      case OpponentPageState.outgoingChallenge:
        page = OutgoingChallengePage(
            changeState: changeState, stateChannel: stateChannel);
        break;
      case OpponentPageState.incomingChallenge:
        page = IncomingChallengePage(
          changeState: changeState,
          challengerId: _challengerId,
          challengerName: _challengerName,
          reset: reset,
          stateChannel: stateChannel,
        );
    }
    return page;
  }

  @override
  void initState() {
    stateChannel = supabase.channel('lobby').subscribe();
    stateChannel.onBroadcast(
        event: 'incoming_challenge',
        callback: (payload) => {
              if (payload['recieverId'] == Player().id)
                {
                  handleIncomingChallenge(
                      payload['challengerId'], payload['challengerName'])
                }
            });
    stateChannel.onBroadcast(
        event: 'challenge_cancelled', callback: (_) => reset());
    stateChannel.onBroadcast(
        event: 'challenge_status',
        callback: (payload) => {
              if (payload['challengerId'] == Player().id)
                {handleChallengeStatus(payload['challenge_status'])}
            });
    stateChannel.onBroadcast(
        event: 'challenge_rejected', callback: (payload) => reset());
    stateChannel.onBroadcast(
        event: 'challenge_accepted',
        callback: (payload) {
          Player().opponentId = payload['recieverId'];
          Player().opponentName = payload['recieverName'];
          supabase.from('players').update({'opponent_id': Player().opponentId});
          // channelName is a combination of the two players' ids
          final String channelName =
              Player().id.toString() + Player().opponentId.toString();
          Get.to(() => GameCountdownPage(
                channelName: channelName,
              ));
        });
    super.initState();
  }

  void handleIncomingChallenge(int challengerId, String challengerName) {
    if (_state != OpponentPageState.findOpponent) {
      stateChannel.sendBroadcastMessage(event: 'challenge_status', payload: {
        'challengerId': challengerId,
        'challenge_status': 'denied'
      });
      return;
    }
    stateChannel.sendBroadcastMessage(
        event: 'challenge_status',
        payload: {'challengerId': challengerId, 'challenge_status': 'ok'});

    _challengerId = challengerId;
    _challengerName = challengerName;
    changeState(OpponentPageState.incomingChallenge);
  }

  void reset() {
    _challengerName = '';
    _challengerId = 0;
    changeState(OpponentPageState.findOpponent);
  }

  void handleChallengeStatus(String challengeStatus) {
    switch (challengeStatus) {
      case 'ok':
        changeState(OpponentPageState.outgoingChallenge);
        break;
      case 'denied':
        break;
    }
  }

  void changeState(OpponentPageState state) {
    setState(() {
      _state = state;
    });
  }
}

class FindOpponentPage extends StatefulWidget {
  const FindOpponentPage(
      {super.key, required this.changeState, required this.stateChannel});
  final Function changeState;
  final RealtimeChannel stateChannel;

  @override
  State<FindOpponentPage> createState() => _FindOpponentPageState();
}

class _FindOpponentPageState extends State<FindOpponentPage> {
  final TextEditingController inputFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Hello ${Player().name}!"),
            TextFormField(
              controller: inputFieldController,
              decoration:
                  const InputDecoration(labelText: ("Enter an opponents name")),
            ),
            ElevatedButton(
                onPressed: () {
                  if (inputFieldController.text.toLowerCase() == 'debug') {
                    Get.to(() => const GamePage(channelName: 'debug'));
                  }
                  challengeOpponent(inputFieldController.text);
                },
                child: const Text("Challenge Opponent")),
            const SizedBox(
              height: 300,
            )
          ],
        ),
      ),
    );
  }

  void challengeOpponent(String name) async {
    if (name == Player().name) {
      return;
    }

    Map<String, dynamic> content;
    try {
      content =
          await supabase.from('players').select('id').eq('name', name).single();
    } catch (_) {
      return;
    }

    final int recieverId = content['id'];

    widget.stateChannel
        .sendBroadcastMessage(event: 'incoming_challenge', payload: {
      'recieverId': recieverId,
      'challengerId': Player().id,
      'challengerName': Player().name
    });
  }
}
