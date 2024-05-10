import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wizardly_fucked_wizards/controllers/ingredient_controller.dart';
import 'package:wizardly_fucked_wizards/controllers/player_controllers.dart';
import 'package:wizardly_fucked_wizards/controllers/potion_controller.dart';
import 'package:wizardly_fucked_wizards/pages/game_page/game_page.dart';

class PostGamePage extends StatelessWidget {
  PostGamePage(
      {super.key, required this.winnerName, required this.channelName});
  final String winnerName;
  final String channelName;
  final IngredientController ingredientController =
      Get.put(IngredientController());
  final PotionController potionController = Get.put(PotionController());
  final YouController youController = Get.put(YouController());
  final OpponentController opponentController = Get.put(OpponentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('The winner is $winnerName!'),
            const SizedBox(height: 200),
            ElevatedButton(
                onPressed: () {
                  // Get.snackbar('No', '');
                  ingredientController.ingredients.clear();
                  potionController.reset();
                  youController.reset();
                  opponentController.reset();
                  Get.to(() => GamePage(channelName: channelName));
                },
                child: const Text('Play Again'))
          ],
        ),
      ),
    );
  }
}
