import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wizardly_fucked_wizards/controllers/potion_controller.dart';
import 'package:wizardly_fucked_wizards/other/potions.dart';
import 'package:wizardly_fucked_wizards/pages/game_page/potion_views.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key, required this.channelName});
  final String channelName;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  PotionController potionController = Get.put(PotionController());

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
                ),
                Player(
                  name: "Opponent",
                  onTap: opponentOnTap,
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
    print(widget.channelName);
    super.initState();
  }

  void youOnTap() {
    PotionFactory.getPotionById(potionController.potionId.value).applyPotion();
  }

  void opponentOnTap() {}
}

class Player extends StatelessWidget {
  const Player({super.key, required this.name, required this.onTap});

  final String name;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        height: 100,
        width: 100,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                width: 2, color: Theme.of(context).colorScheme.primary),
          ),
          child: Center(
            child: Text(name),
          ),
        ),
      ),
    );
  }
}
