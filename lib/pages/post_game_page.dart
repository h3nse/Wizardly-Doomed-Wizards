import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wizardly_fucked_wizards/controllers/ingredient_controller.dart';
import 'package:wizardly_fucked_wizards/controllers/player_controllers.dart';
import 'package:wizardly_fucked_wizards/controllers/potion_controller.dart';
import 'package:wizardly_fucked_wizards/controllers/world_controller.dart';
import 'package:wizardly_fucked_wizards/main.dart';
import 'package:wizardly_fucked_wizards/pages/game_page/game_page.dart';

class PostGamePage extends StatefulWidget {
  const PostGamePage(
      {super.key, required this.winnerName, required this.channelName});
  final String winnerName;
  final String channelName;

  @override
  State<PostGamePage> createState() => _PostGamePageState();
}

class _PostGamePageState extends State<PostGamePage> {
  late RealtimeChannel _broadcastChannel;
  final IngredientController ingredientController =
      Get.put(IngredientController());
  final PotionController potionController = Get.put(PotionController());
  final YouController youController = Get.put(YouController());
  final OpponentController opponentController = Get.put(OpponentController());
  final WorldController worldController = Get.put(WorldController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('The winner is ${widget.winnerName}!'),
            const SizedBox(height: 200),
            ElevatedButton(
                onPressed: () {
                  Get.snackbar('Game Restarted', '');
                  _broadcastChannel
                      .sendBroadcastMessage(event: 'play_again', payload: {});
                  playAgain();
                },
                child: const Text('Play Again'))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _broadcastChannel = supabase.channel(widget.channelName).subscribe();
    _broadcastChannel.onBroadcast(
        event: 'play_again',
        callback: (_) {
          Get.snackbar('Game Restarted', '');
          playAgain();
        });
    super.initState();
  }

  void playAgain() {
    ingredientController.ingredients.clear();
    potionController.reset();
    youController.reset();
    opponentController.reset();
    worldController.reset();
    Get.to(() => GamePage(channelName: widget.channelName));
  }
}
