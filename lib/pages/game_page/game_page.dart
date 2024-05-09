import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wizardly_fucked_wizards/controllers/player_controllers.dart';
import 'package:wizardly_fucked_wizards/controllers/potion_controller.dart';
import 'package:wizardly_fucked_wizards/main.dart';
import 'package:wizardly_fucked_wizards/other/constants.dart';
import 'package:wizardly_fucked_wizards/other/player.dart';
import 'package:wizardly_fucked_wizards/other/potions.dart';
import 'package:wizardly_fucked_wizards/pages/game_page/potion_views.dart';
import 'package:wizardly_fucked_wizards/pages/post_game_page.dart';

// TODO: Show players who is drinking/throwing what.
// TODO: Implement conditions

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.channelName});
  final String channelName;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final RealtimeChannel _broadcastChannel;
  PotionController potionController = Get.put(PotionController());
  YouController youController = Get.put(YouController());
  OpponentController opponentController = Get.put(OpponentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PlayerView(
                  name: "You",
                  onTap: youOnTap,
                  playerController: youController,
                ),
                PlayerView(
                  name: "Opponent",
                  onTap: opponentOnTap,
                  playerController: opponentController,
                )
              ],
            ),
            const PotionView(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _broadcastChannel = supabase.channel(widget.channelName).subscribe();
    youController.setBroadcastChannel(_broadcastChannel);
    youController.setOnDeath(youOnDeath);

    _broadcastChannel.onBroadcast(
        event: 'opponent_update',
        callback: (payload) => updateOpponent(payload));

    _broadcastChannel.onBroadcast(
        event: 'potion_action',
        callback: (payload) =>
            handlePotionAction(payload['potionId'], payload['isThrown']));

    _broadcastChannel.onBroadcast(
        event: 'opponent_death', callback: (_) => opponentOnDeath());
    super.initState();
  }

  void youOnTap() {
    PotionFactory.getPotionById(potionController.potionId.value).applyPotion();
    potionController.potionId.value = 0;
    potionController.potionState.value = PotionState.empty;
    // Animation
  }

  void opponentOnTap() {
    _broadcastChannel.sendBroadcastMessage(event: 'potion_action', payload: {
      'potionId': potionController.potionId.value,
      'isThrown': true
    });
    // Animation
    potionController.potionId.value = 0;
    potionController.potionState.value = PotionState.empty;
  }

  void youOnDeath() {
    _broadcastChannel
        .sendBroadcastMessage(event: 'opponent_death', payload: {});
    Get.to(() => PostGamePage(winnerName: Player().opponentName));
  }

  void opponentOnDeath() {
    Get.to(() => PostGamePage(winnerName: Player().name));
  }

  void updateOpponent(Map<String, dynamic> updates) {
    opponentController.health = updates['health'];
  }

  void handlePotionAction(int potionId, bool isThrown) {
    if (!isThrown) {
      // Animation
      return;
    }

    PotionFactory.getPotionById(potionId).applyPotion();
    // Animation
  }
}

class PlayerView extends StatefulWidget {
  const PlayerView(
      {super.key,
      required this.name,
      required this.onTap,
      required this.playerController});

  final String name;
  final Function onTap;
  final PlayerController playerController;

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            widget.onTap();
          },
          child: SizedBox(
            height: 100,
            width: 100,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    width: 2, color: Theme.of(context).colorScheme.primary),
              ),
              child: Center(
                child: Text(widget.name),
              ),
            ),
          ),
        ),
        Obx(() => Text(widget.playerController.health.toString()))
      ],
    );
  }
}
