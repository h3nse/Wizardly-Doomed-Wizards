import 'dart:async';

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

import 'player_view.dart';

// TODO: Show players who is drinking/throwing what.
// TODO: Implement conditions
// TODO: Connect coldness to mix speed

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.channelName});
  final String channelName;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final RealtimeChannel _broadcastChannel;
  late final Timer timer;
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
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PlayerView(
                    name: "You",
                    onTap: youOnTap,
                    playerController: youController,
                    disableOnTap: youController.isFrozen,
                  ),
                  PlayerView(
                    name: "Opponent",
                    onTap: opponentOnTap,
                    playerController: opponentController,
                    disableOnTap: youController.isFrozen,
                  )
                ],
              ),
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

    timer = Timer.periodic(const Duration(milliseconds: tickDelayMs), (timer) {
      worldUpdate();
    });
    super.initState();
  }

  @override
  void dispose() {
    _broadcastChannel.unsubscribe();
    timer.cancel();
    super.dispose();
  }

  void youOnTap() {
    if (potionController.potionState.value != PotionState.finished) return;
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
    Get.to(() => PostGamePage(
          winnerName: Player().opponentName,
          channelName: widget.channelName,
        ));
  }

  void opponentOnDeath() {
    Get.to(() => PostGamePage(
          winnerName: Player().name,
          channelName: widget.channelName,
        ));
  }

  void updateOpponent(Map<String, dynamic> updates) {
    opponentController.health = updates['health'];
    opponentController.temperature = updates['temperature'];
    opponentController.isFrozen = updates['isFrozen'];
  }

  void handlePotionAction(int potionId, bool isThrown) {
    if (!isThrown) {
      // Animation
      return;
    }

    PotionFactory.getPotionById(potionId).applyPotion();
    // Animation
  }

  void worldUpdate() {
    // If your temperature is above 10, you take damage
    if (youController.temperature > 10) youController.health--;

    // If your temperature is below 15, you become frozen
    youController.isFrozen = youController.temperature < -18;
    if (youController.temperature < -15) youController.damageMultiplier = 2.0;

    // Move temperature towards 0
    if (youController.temperature < 0) youController.temperature++;
    if (youController.temperature > 0) youController.temperature--;

    // If your temperature is above 15, you catch fire and have have a permanent temperature of 20
    if (youController.temperature > 15) youController.temperature = 20;
    youController.sendUpdates();
  }
}
