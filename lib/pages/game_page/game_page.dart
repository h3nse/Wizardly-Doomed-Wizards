import 'dart:async';
import 'dart:math';
import 'package:async/async.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wizardly_fucked_wizards/controllers/player_controllers.dart';
import 'package:wizardly_fucked_wizards/controllers/potion_controller.dart';
import 'package:wizardly_fucked_wizards/controllers/world_controller.dart';
import 'package:wizardly_fucked_wizards/main.dart';
import 'package:wizardly_fucked_wizards/other/constants.dart';
import 'package:wizardly_fucked_wizards/other/player.dart';
import 'package:wizardly_fucked_wizards/other/potions.dart';
import 'package:wizardly_fucked_wizards/pages/game_page/potion_views.dart';
import 'package:wizardly_fucked_wizards/pages/post_game_page.dart';

import 'player_view.dart';

// TODO: Show players who is drinking/throwing what.
// TODO: Connect coldness to mix speed

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
  late final RestartableTimer weathertimer;
  PotionController potionController = Get.put(PotionController());
  YouController youController = Get.put(YouController());
  OpponentController opponentController = Get.put(OpponentController());
  WorldController worldController = Get.put(WorldController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Obx(() => Text(worldController.currentWeather.toString())),
              ),
            ),
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
    worldController.setBroadcastChannel(_broadcastChannel);

    _broadcastChannel.onBroadcast(
        event: 'opponent_update',
        callback: (payload) => updateOpponent(payload));

    _broadcastChannel.onBroadcast(
        event: 'potion_action',
        callback: (payload) =>
            handlePotionAction(payload['potionId'], payload['isThrown']));

    _broadcastChannel.onBroadcast(
        event: 'opponent_death', callback: (_) => opponentOnDeath());

    temperatureTimer = Timer.periodic(
        const Duration(milliseconds: temperatureDelayMs), (timer) {
      temperatureUpdate();
    });
    updateTimer =
        Timer.periodic(const Duration(milliseconds: updateDelayMs), (timer) {
      update();
    });
    final Random random = Random();
    if (Player().isManager) {
      weathertimer = RestartableTimer(
          Duration(
              seconds: weatherDelayMin +
                  random.nextInt(weatherDelayMax - weatherDelayMin)), () {
        weatherEvent();
      });
    } else {
      _broadcastChannel.onBroadcast(
          event: 'weather_update',
          callback: (payload) {
            worldController.currentWeather =
                Weather.values[payload['currentWeatherIndex']];
          });
    }
    super.initState();
  }

  @override
  void dispose() {
    _broadcastChannel.unsubscribe();
    updateTimer.cancel();
    temperatureTimer.cancel();
    weathertimer.cancel();
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

  int currentTemperatureLimitMin = temperatureLimitMin;
  int currentTemperatureLimitMax = temperatureLimitMax;

  void handlePotionAction(int potionId, bool isThrown) {
    if (!isThrown) {
      // Animation
      return;
    }

    PotionFactory.getPotionById(potionId).applyPotion();
    // Animation
  }

  void update() {
    // Rain effects
    if (worldController.currentWeather == Weather.rain) {
      youController.isWet = true;
    }

    // Thunderstorm effects
    if (worldController.currentWeather == Weather.thunderStorm) {
      // Math to make sure the chance per 5 seconds is correct
      const double numberOfIntervals = 5000 / updateDelayMs;
      final double probabilityPerInterval = 1 -
          pow((1 - lightningStrikeChance), 1 / numberOfIntervals).toDouble();

      final Random random = Random();
      if (random.nextDouble() < probabilityPerInterval) {
        youController.takeDamage(thunderStormDamage);
        youController.isCharged = true;
      }
    }

    // If your temperature is below a certain point, you take more damage from physical attacks
    if (youController.temperature < brittleThreshold) {
      youController.damageMultiplier = 2.0;
    } else {
      youController.damageMultiplier = 1.0;
    }

    // If your temperature is below a certain point, you become frozen
    if (youController.temperature < freezeThreshold) {
      youController.isFrozen = true;
      youController.isWet = false;
    } else {
      youController.isFrozen = false;
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
      youController.temperature = currentTemperatureLimitMax;
    }

    // If you're wet and your temperature is above a certain point, your temperature goes down and you become dry
    if (youController.isWet &&
        youController.temperature > wetCooldownThreshold) {
      youController.temperature -= wetCooldownAmount;
      youController.isWet = false;
    }

    youController.sendUpdates();
  }

  void temperatureUpdate() {
    // Move temperature towards 0
    if (!youController.isOvercharged &&
        !(youController.temperature == currentTemperatureLimitMax)) {
      int target = 0;
      int changeAmount = 1;

      if (youController.isCharged) changeAmount = 2;

      if (worldController.currentWeather == Weather.blizzard) {
        currentTemperatureLimitMax = blizzardMaxTemp;
        target = temperatureLimitMin;
        changeAmount = 1;
      } else if (worldController.currentWeather == Weather.heatWave) {
        currentTemperatureLimitMin = heatwaveMinTemp;
        target = temperatureLimitMax;
        changeAmount = 1;
      } else {
        currentTemperatureLimitMax = temperatureLimitMax;
        currentTemperatureLimitMin = temperatureLimitMin;
      }

      moveTemperatureTowards(target, changeAmount);

      // If your temperature is above a certain point, you catch fire and have have a permanent temperature of 20
      if (youController.temperature > fireThreshold) {
        youController.temperature = currentTemperatureLimitMax;
      }
    }

    // If your temperature is above a certain point, you take damage
    if (youController.temperature > heatDamageThreshold) {
      youController.takeDamage(heatDamage);
    }
  }

  void moveTemperatureTowards(int target, int amount) {
    if (youController.temperature > target) {
      youController.cool(min(amount, youController.temperature - target));
    }
    if (youController.temperature < target) {
      youController.heat(min(amount, target - youController.temperature));
    }
  }

  void weatherEvent() {
    final Random random = Random();
    // Add 2 since 'clear' is the first type in the list, and we want to exclude that and .nextInt and .length are off by 1.
    worldController.currentWeather =
        Weather.values[2 + random.nextInt(Weather.values.length - 2)];

    Timer(
        Duration(
            seconds: weatherDurationMin +
                random.nextInt(weatherDurationMax - weatherDurationMin)), () {
      worldController.currentWeather = Weather.clear;
      weathertimer.reset();
    });
  }
}
