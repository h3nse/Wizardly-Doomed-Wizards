import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wizardly_fucked_wizards/controllers/player_controllers.dart';
import 'package:wizardly_fucked_wizards/controllers/potion_controller.dart';
import 'package:wizardly_fucked_wizards/main.dart';
import 'package:wizardly_fucked_wizards/other/potions.dart';
import 'package:wizardly_fucked_wizards/pages/game_page/potion_views.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.channelName});
  final String channelName;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final RealtimeChannel _duelChannel;
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
                Player(
                  name: "You",
                  onTap: youOnTap,
                  playerController: youController,
                ),
                Player(
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
    _duelChannel = supabase.channel(widget.channelName).subscribe();
    _duelChannel.onBroadcast(
        event: 'opponent_update',
        callback: (payload) => updateOpponent(payload));
    super.initState();
  }

  void youOnTap() {
    print("you on tap");
    PotionFactory.getPotionById(potionController.potionId.value).applyPotion();
  }

  void opponentOnTap() {}

  void updateOpponent(Map<String, dynamic> updates) {}
}

class Player extends StatefulWidget {
  const Player(
      {super.key,
      required this.name,
      required this.onTap,
      required this.playerController});

  final String name;
  final Function onTap;
  final PlayerController playerController;

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
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
        Obx(() => Text(widget.playerController.health.value.toString()))
      ],
    );
  }
}
