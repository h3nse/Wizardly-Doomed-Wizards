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
// TODO: Connect coldness to mix speed
// TODO: Add raincloud indicator

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.channelName});
  final String channelName;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final RealtimeChannel _broadcastChannel;
  late final Timer updateTimer;
  late final Timer temperatureTimer;
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
              () => Expanded(
                child: Row(
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
            ),
            const Expanded(child: PotionView()),
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

    updateTimer = Timer.periodic(
        const Duration(milliseconds: temperatureDelayMs), (timer) {
      temperatureUpdate();
    });
    temperatureTimer =
        Timer.periodic(const Duration(milliseconds: updateDelayMs), (timer) {
      worldUpdate();
    });
    super.initState();
  }

  @override
  void dispose() {
    _broadcastChannel.unsubscribe();
    updateTimer.cancel();
    temperatureTimer.cancel();
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
    opponentController.isCharged = updates['isCharged'];
    opponentController.isOvercharged = updates['isOvercharged'];
    opponentController.isWet = updates['isWet'];
    opponentController.hasRainCloud = updates['hasRainCloud'];
  }

  void handlePotionAction(int potionId, bool isThrown) {
    if (!isThrown) {
      // Animation
      return;
    }

    PotionFactory.getPotionById(potionId).applyPotion();
    // Animation
  }

  void temperatureUpdate() {
    // Move temperature towards 0
    if (!youController.isOvercharged &&
        !(youController.temperature == temperatureLimitMax)) {
      int tempChange = 1;
      if (youController.isCharged) tempChange = 2;
      if (youController.temperature < 0) {
        youController.temperature += tempChange;
      }
      if (youController.temperature > 0) {
        youController.temperature -= tempChange;
      }

      // If your temperature is above a certain point, you catch fire and have have a permanent temperature of 20
      if (youController.temperature > fireThreshold) {
        youController.temperature = temperatureLimitMax;
      }
    }

    // If your temperature is above a certain point, you take damage
    if (youController.temperature > heatDamageThreshold) {
      youController.health--;
    }
  }

  void worldUpdate() {
    // If your temperature is below a certain point, you take more damage from physical attacks
    if (youController.temperature < brittleThreshold) {
      youController.damageMultiplier = 2.0;
    }

    // If your temperature is below a certain point, you become frozen
    if (youController.temperature < freezeThreshold) {
      youController.isFrozen = true;
      youController.isWet = false;
    }

    // If you are charged and wet, you take damage and lose your charge
    if (youController.isCharged && youController.isWet) {
      int damage = wetAndChargedDamage;
      if (youController.isOvercharged) {
        damage = damage * 2;
        youController.isOvercharged = false;
      }
      youController.takeDamage(damage);
      youController.isCharged = false;
    }

    // If you are overcharged, your temperature is at max
    if (youController.isOvercharged) {
      youController.temperature = temperatureLimitMax;
    }

    // If you're wet and your temperature is above a certain point, your temperature goes down and you become dry
    if (youController.isWet &&
        youController.temperature > wetCooldownThreshold) {
      youController.temperature -= wetCooldownAmount;
      youController.isWet = false;
    }

    youController.sendUpdates();
  }
}
